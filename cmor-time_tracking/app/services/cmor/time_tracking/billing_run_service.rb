module Cmor
  module TimeTracking
    class BillingRunService < Rao::Service::Base
      class Result < Rao::Service::Result::Base
        attr_accessor :invoices, :billed_items
      end

      attr_accessor :item_ids, :items, :item_id_to_rate_id_map, :rates, :bill_monthly

      validates :items, presence: true

      def bill_monthly=(value)
        @bill_monthly = ActiveRecord::Type::Boolean.new.cast(value)
      end

      def items
        @items ||= Cmor::TimeTracking::Item.where(id: item_ids).map { |item| Cmor::TimeTracking::BillingRunService::Item.new(item: item) }
      end

      def items=(value)
        @items = case value
        when Hash
          value.collect do |item_id, attributes|
            next unless ActiveRecord::Type::Boolean.new.cast(attributes.delete(:selected))
            project_rate_id = attributes.delete(:project_rate_id)
            project_rate = Cmor::TimeTracking::ProjectRate.find_by(id: project_rate_id)
            item = Cmor::TimeTracking::Item.find(item_id)
            invoice_owner = GlobalID::Locator.locate(attributes.delete(:invoice_owner_gid))
            Cmor::TimeTracking::BillingRunService::Item.new(attributes.merge(item: item, project_rate: project_rate, invoice_owner: invoice_owner))
          end.compact
        when Array
          value.collect do |item|
            if item.is_a?(Cmor::TimeTracking::Item)
              Cmor::TimeTracking::BillingRunService::Item.new(item: item, project_rate: item.project&.current_default_rate, invoice_owner: item.issue.project&.owner)
            else
              item
            end
          end
        else
          value
        end
      end

      private

      def _perform
        @result.invoices = []
        @result.billed_items = []

        items.each do |item|
          next if item.valid?
          add_error_and_say(:"items[#{item.item.id}]", item.errors.full_messages.to_sentence)
        end
        return if @errors.any?

        if bill_monthly
          perform_monthly_billing
        else
          perform_billing
        end
      end

      def perform_billing
        # iterate over invoice owners
        invoice_owners.each do |invoice_owner|
          # build invoice for project
          invoice = build_invoice(invoice_owner)
          # select billable items for invoice_owner
          billable_items = items.select { |item| item.invoice_owner == invoice_owner && item.billable? }
          # group billable_items by issue
          billable_items_by_issue = billable_items.group_by(&:issue)

          # skip if no billable items are present
          next if billable_items_by_issue.blank?

          # add issues to invoice
          billable_items_by_issue.each do |issue, items|
            items.group_by(&:rate).each do |rate, items|
              invoice.line_items << build_line_item(invoice, rate, issue, items)
              @result.billed_items << items
            end
          end

          @result.billed_items.flatten!

          invoice.shipping_date = billable_items.map(&:start_at).min.beginning_of_month
          invoice.shipping_end_date = billable_items.map(&:start_at).max.end_of_month

          # add invoice to result
          @result.invoices << invoice
        end
      end

      def perform_monthly_billing
        say "Billing #{months.size} month(s)" do
          # iterate over months
          months.each do |month|
            say "Billing month #{month.to_date}" do
              # iterate over invoice owners
              invoice_owners.each do |invoice_owner|
                say "Billing invoice owner #{invoice_owner.human}" do
                  binding.pry if invoice_owner.nil?
                  # build invoice for month and project
                  invoice = build_invoice(invoice_owner, month)
                  # select billable items for year, month and project and group them by issue
                  billable_items_by_issue = items.select { |item| item.invoice_owner == invoice_owner && item.start_at.beginning_of_month == month.beginning_of_month && item.billable? }.group_by(&:issue)

                  # skip if no billable items are present
                  if billable_items_by_issue.blank?
                    say "No billable items found. Skipping."
                    next
                  end

                  # add issues to invoice
                  billable_items_by_issue.each do |issue, items|
                    items.group_by(&:rate).each do |rate, items|
                      invoice.line_items << build_line_item(invoice, rate, issue, items)
                      @result.billed_items << items
                    end
                  end

                  @result.billed_items.flatten!

                  # add invoice to result
                  @result.invoices << invoice
                end
              end
            end
          end
        end
      end

      def save
        ActiveRecord::Base.transaction do
          @result.invoices.map(&:save!)
          @result.billed_items.map(&:mark_as_billed!)
        end
      end

      def build_invoice(invoice_owner, month = nil)
        Bgit::Invoicing::Invoice.new(
          owner: invoice_owner,
          shipping_date: month&.beginning_of_month,
          shipping_end_date: month&.end_of_month
        )
      end

      def build_line_item(invoice, rate, issue, items)
        Bgit::Invoicing::LineItem.new.tap do |li|
          li.invoice = invoice
          li.name = issue.identifier
          li.description = issue.summary
          li.unit_name = rate.unit_name
          li.quantity = items.sum(&:duration_in_hours)
          li.unit_net_amount_cents = rate.unit_net_amount_cents
          li.tax_rate_percentage = rate.unit_tax_rate_percentage
          li.billed_items.build(items.map { |item| {billable: item.item} })
          binding.pry if li.invalid?
        end
      end

      def rate_ids
        @rate_ids ||= item_id_to_rate_id_map.keys
      end

      def rates
        @rates ||= Cmor::TimeTracking::Rate.where(id: rate_ids)
      end

      def issues
        @issues ||= items.map(&:issue).uniq
      end

      def months
        @months ||= items.map { |item| item.start_at.beginning_of_month }.uniq
      end

      def projects
        @projects ||= items.map(&:project).uniq
      end

      def invoice_owners
        @invoice_owners ||= items.map(&:invoice_owner).uniq
      end
    end
  end
end

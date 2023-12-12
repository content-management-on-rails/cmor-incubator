module Cmor
  module TimeTracking
    class BillingRunService < Rao::Service::Base
      class Result < Rao::Service::Result::Base
        attr_accessor :invoices, :billed_items
      end

      attr_accessor :item_ids, :items, :item_id_to_rate_id_map, :rates

      validates :items, presence: true

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
            Cmor::TimeTracking::BillingRunService::Item.new(attributes.merge(item: item, project_rate: project_rate))
          end
        else
          value
        end
      end

      private

      def _perform
        items.each do |item|
          next if item.valid?
          add_error_and_say(:"items[#{item.item.id}]", item.errors.full_messages.to_sentence)
        end

        @result.invoices = []
        @result.billed_items = []

        # iterate over months
        months.each do |month|
          # iterate over projects
          projects.each do |project|
            # build invoice for month and project
            invoice = build_invoice(month, project)
            # select billable items for year, month and project and group them by issue
            billable_items_by_issue = items.select { |item| item.project == project && item.start_at.beginning_of_month == month.beginning_of_month && item.billable? }.group_by(&:issue)

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

            # add invoice to result
            @result.invoices << invoice
          end
        end
      end

      def save
        ActiveRecord::Base.transaction do
          @result.invoices.map(&:save!)
          @result.billed_items.map(&:mark_as_billed!)
        end
      end

      def build_invoice(month, project)
        Bgit::Invoicing::Invoice.new(
          owner: project.owner,
          year: month.year,
          month: month.month
        )
      end

      def build_line_item(invoice, rate, issue, items)
        Bgit::Invoicing::LineItem.new(
          invoice: invoice,
          invoiceable: issue,
          name: issue.identifier,
          description: issue.summary,
          unit_name: rate.unit_name,
          quantity: items.sum(&:duration_in_hours),
          unit_net_amount_cents: rate.unit_net_amount_cents,
          tax_rate_percentage: rate.unit_tax_rate_percentage
        )
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
    end
  end
end

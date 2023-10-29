module Cmor
  module TimeTracking
    class ItemsReportService < Rao::Service::Base
      class Result < Rao::Service::Result::Base
        attr_accessor :count,
          :hours,
          :draft_hours,
          :confirmed_hours,
          :billable_hours,
          :not_billable_hours,
          :billed_hours
      end

      attr_accessor :items

      validates :items, presence: true

      private

      def _perform
        @result.count = count
        @result.hours = hours
        @result.draft_hours = draft_hours
        @result.confirmed_hours = confirmed_hours
        @result.billable_hours = billable_hours
        @result.not_billable_hours = not_billable_hours
        @result.billed_hours = billed_hours
      end

      def count
        items.count
      end

      def hours
        (items.sum(:duration).to_f / 60 / 60).round(3)
      end

      def draft_hours
        (items.where(billing_state: :draft).sum(:duration).to_f / 60 / 60).round(3)
      end

      def confirmed_hours
        (items.where(billing_state: :confirmed).sum(:duration).to_f / 60 / 60).round(3)
      end

      def billable_hours
        (items.where(billing_state: :billable).sum(:duration).to_f / 60 / 60).round(3)
      end

      def not_billable_hours
        (items.where(billing_state: :not_billable).sum(:duration).to_f / 60 / 60).round(3)
      end

      def billed_hours
        (items.where(billing_state: :billed).sum(:duration).to_f / 60 / 60).round(3)
      end
    end
  end
end

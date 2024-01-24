module Cmor
  module TimeTracking
    class ProjectReportService < Rao::Service::Base
      class Result < Rao::Service::Result::Base
        attr_accessor :issues_count,
          :items_count,
          :hours,
          :draft_hours,
          :confirmed_hours,
          :billable_hours,
          :not_billable_hours,
          :billed_hours,
          :visibility,
          :available_hours_attributes
      end

      attr_accessor :project
      attr_writer :visibility

      validates :project, presence: true
      validates :visibility, inclusion: { in: %w(all customer).map(&:inquiry) }, allow_blank: true

      private

      def visibility
        @visibility.to_s.inquiry
      end

      def available_hours_attributes
        @available_hour_attributes ||= if visibility.all?
          %w(draft_hours confirmed_hours billable_hours not_billable_hours billed_hours)
        else
          %w(billable_hours billed_hours)
        end
      end

      def _perform
        @result.visibility = visibility
        @result.available_hours_attributes = available_hours_attributes

        if visibility.all?
          @result.items_count = items_count
          @result.draft_hours = draft_hours
          @result.confirmed_hours = confirmed_hours
          @result.not_billable_hours = not_billable_hours
          @result.hours = hours
          @result.issues_count = issues_count
        end
        @result.billable_hours = billable_hours
        @result.billed_hours = billed_hours
      end

      def issues_count
        @project.issues_count
      end

      def items_count
        @project.items_count
      end

      def hours
        @project.hours
      end

      def draft_hours
        @project.draft_hours
      end

      def confirmed_hours
        @project.confirmed_hours
      end

      def billable_hours
        @project.billable_hours
      end

      def not_billable_hours
        @project.not_billable_hours
      end

      def billed_hours
        @project.billed_hours
      end
    end
  end
end

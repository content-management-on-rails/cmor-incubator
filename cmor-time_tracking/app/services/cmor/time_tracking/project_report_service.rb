module Cmor
  module TimeTracking
    class ProjectReportService < Rao::Service::Base
      class Result < Rao::Service::Result::Base
        attr_accessor :issues_count,
          :items_count,
          :hours,
          :draft_hours,
          :confirmed_hours,
          :flatrate_hours,
          :billable_hours,
          :not_billable_hours,
          :billed_hours
      end

      attr_accessor :project

      validates :project, presence: true

      private

      def _perform
        @result.issues_count = issues_count
        @result.items_count = items_count
        @result.hours = hours
        @result.draft_hours = draft_hours
        @result.confirmed_hours = confirmed_hours
        @result.flatrate_hours = @project.flatrate_hours
        @result.billable_hours = billable_hours
        @result.not_billable_hours = not_billable_hours
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

      def flatrate_hours
        @project.flatrate_hours
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

module Cmor
  module TimeTracking
    class ItemsByProjectReportService < Rao::Service::Base
      class Result < Rao::Service::Result::Base
        attr_accessor :projects,
          :months,
          :items

        def items_by_month_for_project(project)
          months.map do |month|
            # select items for project and month
            @items.select { |item| item.project == project && item.start_at.beginning_of_month == month.beginning_of_month }
          end
        end
      end

      attr_accessor :items

      validates :items, presence: true

      private

      def _perform
        @result.items = items
        @result.projects = items.map(&:project).uniq.compact.sort
        @result.months = items.map { |item| item.start_at.beginning_of_month }.uniq.sort
      end
    end
  end
end

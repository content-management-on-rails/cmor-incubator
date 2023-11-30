module Cmor
  module TimeTracking
    class ProjectRatesController < Cmor::Core::Backend::ResourcesController::Base
      include Rao::ResourcesController::SortingConcern

      def self.resource_class
        Cmor::TimeTracking::ProjectRate
      end

      private

      def load_collection_scope
        super.joins(:project, :rate)
      end

      def permitted_params
        params.require(:project_rate).permit(:project_id, :rate_id, :active_from, :active_to)
      end
    end
  end
end

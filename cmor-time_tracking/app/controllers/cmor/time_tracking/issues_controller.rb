module Cmor
  module TimeTracking
    class IssuesController < Cmor::Core::Backend::ResourcesController::Base
      include Rao::ResourcesController::SortingConcern

      def self.resource_class
        Cmor::TimeTracking::Issue
      end

      private

      def load_collection_scope
        super.includes(:project)
      end

      def permitted_params
        params.require(:issue).permit(:description, :identifier, :project_id, :summary)
      end
    end
  end
end

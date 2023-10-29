module Cmor
  module TimeTracking
    class ProjectsController < Cmor::Core::Backend::ResourcesController::Base
      include Rao::ResourcesController::SortingConcern

      view_helper Cmor::TimeTracking::ApplicationViewHelper, as: :time_tracking_helper

      def self.resource_class
        Cmor::TimeTracking::Project
      end

      private

      def permitted_params
        params.require(:project).permit(:description, :identifier, :name)
      end
    end
  end
end

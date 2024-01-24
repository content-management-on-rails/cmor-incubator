module Cmor
  module TimeTracking
    module Frontend
      class ProjectsController < Cmor::TimeTracking::Frontend::ResourcesController::Base
        view_helper Cmor::TimeTracking::ApplicationViewHelper, as: :time_tracking_helper

        def self.resource_class
          Cmor::TimeTracking::Project
        end

        private

        def load_collection
          @collection = policy_scope(resource_class)
        end

        def load_resource
          @resource = policy_scope(resource_class).find(params[:id])
        end
      end
    end
  end
end

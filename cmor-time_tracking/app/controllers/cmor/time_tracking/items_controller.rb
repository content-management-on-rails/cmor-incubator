module Cmor
  module TimeTracking
    class ItemsController < Cmor::Core::Backend::ResourcesController::Base
      include Rao::ResourcesController::SortingConcern
      include Rao::ResourcesController::AasmConcern
      include Rao::ResourcesController::BatchActionsConcern

      view_helper Cmor::TimeTracking::ApplicationViewHelper, as: :time_tracking_helper

      helper_method :jira_integration_enabled?

      def self.resource_class
        Cmor::TimeTracking::Item
      end

      private

      def after_destroy_many_location
        last_location
      end

      def load_collection_scope
        super.eager_load(:owner, :issue, :project).order(start_at: :desc)
      end

      def permitted_params
        params.require(:item).permit(:description, :end_at, :external_issue_identifier, :owner_id, :start_at)
      end

      def jira_integration_enabled?
        Cmor::Core::Settings.get("cmor_time_tracking/external_issue.jira.integration_enabled")
      end
    end
  end
end

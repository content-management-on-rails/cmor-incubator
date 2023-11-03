module Cmor
  module TimeTracking
    class UpdateIssueFromExternalServicesController < Cmor::Core::Backend::ServiceController::Base
      def self.service_class
        Cmor::TimeTracking::UpdateIssueFromExternalService
      end

      private

      def after_success_location
        last_location || url_for(@result.issue)
      end

      def success_message
        [super, t(".success_message", diff: @result.diff_html)].join(" ").html_safe
      end

      def permitted_params
        params.require(:update_issue_from_external_service).permit(:issue_id)
      end
    end
  end
end

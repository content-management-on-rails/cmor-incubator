module Cmor
  module TimeTracking
    class BillingRunServicesController < Cmor::Core::Backend::ServiceController::Base
      def self.service_class
        Cmor::TimeTracking::BillingRunService
      end

      private

      def permitted_params
        params.require(:billing_run_service).permit(:bill_monthly, items: [:selected, :project_rate_id, :invoice_owner_gid])
      end
    end
  end
end

module Cmor
  module TimeTracking
    class RatesController < Cmor::Core::Backend::ResourcesController::Base
      include Rao::ResourcesController::SortingConcern

      def self.resource_class
        Cmor::TimeTracking::Rate
      end

      private

      def permitted_params
        params.require(:rate).permit(:identifier, :unit_name, :unit_net_amount, :unit_tax_rate_percentage, :description)
      end
    end
  end
end

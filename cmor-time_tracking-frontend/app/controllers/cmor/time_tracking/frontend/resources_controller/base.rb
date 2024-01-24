module Cmor
  module TimeTracking
    module Frontend
      module ResourcesController
        class Base < Cmor::TimeTracking::Frontend::ApplicationController
          before_action :load_collection, only: [:index]
          before_action :load_resource, only: [:show]

          helper Rao::Component::ApplicationHelper

          def self.resource_class
            raise "Please implement #self.resource_class in #{self}"
          end

          def self.available_rest_actions
            %i[index show]
          end

          def available_rest_actions
            self.class.available_rest_actions
          end

          def resource_class
            self.class.resource_class
          end

          helper_method :available_rest_actions, :resource_class

          def index
            authorize(resource_class)
          end

          def show
            authorize(@resource)
          end

          private

          def load_collection
            @collection = resource_class.all
          end

          def load_resource
            @resource = resource_class.find(params[:id])
          end
        end
      end
    end
  end
end

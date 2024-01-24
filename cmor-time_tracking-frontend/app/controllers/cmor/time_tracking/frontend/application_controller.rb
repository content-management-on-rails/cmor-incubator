module Cmor
  module TimeTracking
    module Frontend
      class ApplicationController < Cmor::TimeTracking::Frontend::Configuration.base_controller.constantize
        include Pundit::Authorization
        after_action :verify_authorized

        helper Importmap::ImportmapTagsHelper

        private

        def current_engine
          @current_engine ||= Cmor::TimeTracking::Frontend::Engine
        end

        def pundit_user
          Cmor::TimeTracking::Project.first.owner
        end
      end
    end
  end
end

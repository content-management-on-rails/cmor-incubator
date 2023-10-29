module Cmor
  module TimeTracking
    class HomeController < Cmor::Core::Backend::HomeController::Base
      view_helper Cmor::TimeTracking::ApplicationViewHelper, as: :time_tracking_helper

      helper Rao::Component::ApplicationHelper
    end
  end
end

require "cmor-time_tracking"
require "pundit"

require "cmor/time_tracking/frontend/engine"
require "cmor/time_tracking/frontend/configuration"
require "cmor/time_tracking/frontend/version"

module Cmor
  module TimeTracking
    module Frontend
      def self.configure
        yield Configuration
      end
    end
  end
end

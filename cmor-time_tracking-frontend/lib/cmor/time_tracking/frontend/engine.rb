module Cmor
  module TimeTracking
    module Frontend
      class Engine < ::Rails::Engine
        isolate_namespace Cmor::TimeTracking::Frontend
      end
    end
  end
end

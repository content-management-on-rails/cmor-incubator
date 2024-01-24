module Cmor
  module TimeTracking
    module Frontend
      module Generators
        class InstallGenerator < Rails::Generators::Base
          desc "Generates the initializer"

          source_root File.expand_path("../templates", __FILE__)

          def generate_initializer
            template "initializer.rb", "config/initializers/cmor-time_tracking-frontend.rb"
          end

          def generate_routes
            route File.read(File.join(File.expand_path("../templates", __FILE__), "routes.source"))
          end
        end
      end
    end
  end
end

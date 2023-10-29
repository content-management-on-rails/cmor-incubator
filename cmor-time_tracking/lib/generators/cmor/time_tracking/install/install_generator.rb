module Cmor
  module TimeTracking
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc "Generates the initializer"

        source_root File.expand_path("../templates", __FILE__)

        class_option :item_owner_class_name, type: :string
        class_option :item_owner_factory_name, type: :string

        def initialize(*args)
          super
          @item_owner_class_name = ENV.fetch("CMOR_TIME_TRACKING_ITEM_OWNER_CLASS_NAME") { "User" }
          @item_owner_factory_name = ENV.fetch("CMOR_TIME_TRACKING_ITEM_OWNER_FACTORY_NAME") { "user" }
        end

        def generate_initializer
          template "initializer.rb", "config/initializers/cmor-time_tracking.rb"
        end

        def generate_routes
          route File.read(File.join(File.expand_path("../templates", __FILE__), "routes.source"))
        end
      end
    end
  end
end

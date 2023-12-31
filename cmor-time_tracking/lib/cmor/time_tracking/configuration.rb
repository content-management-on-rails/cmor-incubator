module Cmor
  module TimeTracking
    class Configuration
      class << self
        extend Forwardable

        attr_accessor :values

        def define_option(key, default: nil)
          @values[key] = default
          define_singleton_method(key) do
            @values[key]
          end

          define_singleton_method("#{key}=") do |value|
            @values[key] = value
          end
        end

        def cmor
          Cmor
        end
      end

      @values = {}

      def self.set(key, value)
        @values[key] = value
      end

      def self.get(key)
        @values[key]
      end

      define_option :resources_controllers, default: -> { [] }
      define_option :resource_controllers, default: -> { [] }
      define_option :service_controllers, default: -> { [] }
      define_option :sidebar_controllers, default: -> { [] }

      define_option :item_owner_class, default: -> { User }
      define_option :item_owner_factory_name, default: -> { :user }
      define_option :project_owner_factory_name, default: -> { :user }
      define_option :project_owner_classes, default: -> {
        {
          User => main_app.url_for([:autocomplete, User])
        }
      }
      define_option :default_project_owner, default: -> { User.first_or_create!(email: "jane.doe@domain.local") }
      define_option :default_currency, default: -> { "EUR" }
    end
  end
end

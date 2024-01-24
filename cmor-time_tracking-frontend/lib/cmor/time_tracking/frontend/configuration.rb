module Cmor
  module TimeTracking
    module Frontend
      class Configuration
        class << self
          extend Forwardable

          attr_accessor :values

          def define_option(key, default: nil)
            @values[key] = default
            define_singleton_method(key) do
              @values[key]
            end

            define_singleton_method(:"#{key}=") do |value|
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

        define_option :base_controller, default: -> { "::AppliationController" }
      end
    end
  end
end

module Cmor
  module TimeTracking
    class SeedService < JsonSeeds::SeedService::Base
      class Result < JsonSeeds::SeedService::Result::Base
      end

      private

      def around_perform
        old_adapter = ActiveJob::Base.queue_adapter
        ActiveJob::Base.queue_adapter = :inline
        super
      ensure
        ActiveJob::Base.queue_adapter = old_adapter
      end

      def seed_path
        @seed_path ||= Cmor::TimeTracking::Engine.root.join("db", "seeds")
      end

      def model_name_map
        @model_name_map ||= {
          "user" => "User",
          "item" => "Cmor::TimeTracking::Item",
          "item/owner" => {class_name: "User", as: :owner}
        }
      end

      def attribute_name_map
        @attribute_name_map ||= {
          "Cmor::TimeTracking::Item": {
            user: :owner
          }
        }
      end

      def attribute_value_map
        @attribute_value_map ||= {
          User: {
            email: ->(value) {
              {
                "Nati" => "ng@beegoodit.de",
                "Reinhold" => "rm@beegoodit.de",
                "Robo" => "rva@beegoodit.de"
              }[value]
            }
          }
        }
      end
    end
  end
end

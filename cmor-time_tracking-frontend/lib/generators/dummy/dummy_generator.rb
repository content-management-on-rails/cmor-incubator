require "rails/generators/rails/plugin/plugin_generator"

module Dummy
  class DummyGenerator < Rails::Generators::Base
    # def mute(&block)
    #   shell.mute(&block)
    # end

    def build(meth, *args) # :doc:
      builder.public_send(meth, *args) if builder.respond_to?(meth)
    end

    def dummy_path(path = nil)
      @dummy_path = path if path
      @dummy_path || options[:dummy_path]
    end

    def create_dummy_app(path = nil)
      dummy_path(path) if path

      say_status :vendor_app, dummy_path
      # mute do
      build(:generate_test_dummy)
      build(:test_dummy_config)
      build(:test_dummy_sprocket_assets) unless skip_sprockets?
      build(:test_dummy_clean)
      # ensure that bin/rails has proper dummy_path
      build(:bin, true)
      # end
    end
  end
end

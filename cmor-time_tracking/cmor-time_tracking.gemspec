$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require_relative "../lib/cmor/version"
require_relative "../lib/cmor/core/backend/gemspec"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  Cmor::Core::Backend::Gemspec.defaults(spec)

  # rubocop:disable Layout/ExtraSpacing
  spec.name        = "cmor-time_tracking"
  spec.summary     = "Cmor::TimeTracking."
  spec.description = "Cmor::TimeTracking Backend Module."
  # rubocop:enable Layout/ExtraSpacing

  spec.files = Dir["{app,config,db,lib,spec/factories,spec/files}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "aasm"
  spec.add_dependency "cmor-core-settings"
  spec.add_dependency "httparty"
  spec.add_dependency "money-rails"
  spec.add_dependency "rao-active_collection"
  spec.add_dependency "rao-view_helper"
  spec.add_dependency "rao-service"
  spec.add_dependency "simple_form-polymorphic_associations", ">= 0.0.2"

  spec.add_development_dependency "json_seeds-rails"
  spec.add_development_dependency "dotenv-rails"
  spec.add_development_dependency "selenium-webdriver"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end

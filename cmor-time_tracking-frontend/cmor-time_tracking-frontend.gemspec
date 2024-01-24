$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require_relative "../lib/cmor/version"
require_relative "../lib/cmor/core/frontend/gemspec"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  Cmor::Core::Frontend::Gemspec.defaults(spec)

  # rubocop:disable Layout/ExtraSpacing
  spec.name        = "cmor-time_tracking-frontend"
  spec.summary     = "Cmor::TimeTracking."
  spec.description = "Cmor::TimeTracking Frontend Module."
  # rubocop:enable Layout/ExtraSpacing

  spec.files = Dir["{app,config,db,lib,spec/factories,spec/files}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "cmor-time_tracking"
  spec.add_dependency "pundit"

  spec.add_development_dependency "cssbundling-rails"
  spec.add_development_dependency "importmap-rails"
  spec.add_development_dependency "propshaft"
  spec.add_development_dependency "stimulus-rails"
end

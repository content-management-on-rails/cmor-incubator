require "simple_form-polymorphic_associations/spec_helpers/system"

RSpec.configure do |config|
  config.include SimpleFormPolymorphicAssociations::SpecHelpers::System, type: :system
end

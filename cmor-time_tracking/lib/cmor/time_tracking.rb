require "aasm"
require "bgit-invoicing"
require "cmor-core-backend"
require "cmor-core-settings"
require "httparty"
require "money-rails"
require "rao-active_collection"
require "rao-service"
require "rao-view_helper"
require "rao/service/job"
require "simple_form-polymorphic_associations"
require "validates_overlap"

require "cmor/time_tracking/version"
require "cmor/time_tracking/configuration"
require "cmor/time_tracking/engine"

module Cmor
  module TimeTracking
    def self.configure
      yield Configuration
    end
  end
end

module Cmor
  module TimeTracking
    class ExternalIssue::StatusCategory < Rao::ActiveCollection::Base
      attr_accessor :color_name, :key, :name, :id, :url
    end
  end
end

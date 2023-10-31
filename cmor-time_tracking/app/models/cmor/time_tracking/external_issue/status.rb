module Cmor
  module TimeTracking
    class ExternalIssue::Status < Rao::ActiveCollection::Base
      attr_accessor :description, :iconUrl, :id, :name, :statusCategory, :url
    end
  end
end

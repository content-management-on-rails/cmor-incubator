module Cmor
  module TimeTracking
    class ExternalIssue::Issuetype < Rao::ActiveCollection::Base
      attr_accessor :url,
        :id,
        :description,
        :icon_url,
        :name,
        :subtask,
        :avatar_id,
        :hierarchy_level
    end
  end
end

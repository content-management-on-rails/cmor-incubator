module Cmor
  module TimeTracking
    class ExternalIssue::Issuetype < Rao::ActiveCollection::Base
      attr_accessor :url,
        :id,
        :description,
        :iconUrl,
        :name,
        :subtask,
        :avatarId,
        :hierarchyLevel
    end
  end
end

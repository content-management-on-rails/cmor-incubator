module Cmor::TimeTracking
  class Issue < ApplicationRecord
    belongs_to :project
    has_many :items, dependent: :restrict_with_error

    validates :identifier, presence: true, uniqueness: {scope: :project_id}

    def external_issue
      return nil if identifier.blank?
      @external_issue ||= Cmor::TimeTracking::ExternalIssue.find(identifier)
    end

    def human
      "#{project.identifier}##{identifier}"
    end

    def items_count
      items.count
    end
  end
end

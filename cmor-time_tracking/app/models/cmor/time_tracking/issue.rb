module Cmor::TimeTracking
  class Issue < ApplicationRecord
    belongs_to :project
    has_many :items, dependent: :restrict_with_error

    validates :identifier, presence: true, uniqueness: {scope: :project_id}

    def external_issue
      return nil if identifier.blank?
      @external_issue ||= Cmor::TimeTracking::ExternalIssue.where(id: identifier).first
    end

    def human
      "#{project.identifier}##{identifier}"
    end

    def items_count
      items.count
    end

    def items_hours
      items.sum(:duration).to_f / 60 / 60
    end

    def items_draft_hours
      items.draft.sum(:duration).to_f / 60 / 60
    end

    def items_confirmed_hours
      items.confirmed.sum(:duration).to_f / 60 / 60
    end

    def items_billable_hours
      items.billable.sum(:duration).to_f / 60 / 60
    end

    def items_not_billable_hours
      items.not_billable.sum(:duration).to_f / 60 / 60
    end

    def items_billed_hours
      items.billed.sum(:duration).to_f / 60 / 60
    end
  end
end

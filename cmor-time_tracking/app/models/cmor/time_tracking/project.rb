module Cmor::TimeTracking
  class Project < ApplicationRecord
    has_many :issues, dependent: :destroy
    has_many :items, through: :issues

    validates :identifier, presence: true, uniqueness: true

    def human
      identifier
    end

    def issues_count
      issues.count
    end

    def items_count
      items.count
    end

    def hours
      (items.sum(:duration).to_f / 60 / 60).round(3)
    end

    def draft_hours
      (items.where(billing_state: :draft).sum(:duration).to_f / 60 / 60).round(3)
    end

    def confirmed_hours
      (items.where(billing_state: :confirmed).sum(:duration).to_f / 60 / 60).round(3)
    end

    def billable_hours
      (items.where(billing_state: :billable).sum(:duration).to_f / 60 / 60).round(3)
    end

    def billed_hours
      (items.where(billing_state: :billed).sum(:duration).to_f / 60 / 60).round(3)
    end

    def not_billable_hours
      (items.where(billing_state: :not_billable).sum(:duration).to_f / 60 / 60).round(3)
    end
  end
end

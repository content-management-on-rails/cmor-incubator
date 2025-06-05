module Cmor::TimeTracking
  class Project < ApplicationRecord
    belongs_to :owner, polymorphic: true
    has_many :issues, dependent: :destroy
    has_many :items, through: :issues
    has_many :project_rates, dependent: :destroy
    has_many :rates, through: :project_rates
    has_many :current_rates, -> { active_now }, class_name: "Cmor::TimeTracking::ProjectRate" do
      def default
        includes(:rate).where(cmor_time_tracking_rates: {identifier: "default"}).first
      end
    end
    has_one :current_default_rate, -> { active_now.where(identifier: "default") }, class_name: "Cmor::TimeTracking::ProjectRate"
    validates :identifier, presence: true, uniqueness: true

    scope :owned_by_any, ->(*owners) { where(owner: owners.flatten) }

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

    def flatrate_hours
      (items.where(billing_state: :flatrate).sum(:duration).to_f / 60 / 60).round(3)
    end

    def billed_hours
      (items.where(billing_state: :billed).sum(:duration).to_f / 60 / 60).round(3)
    end

    def not_billable_hours
      (items.where(billing_state: :not_billable).sum(:duration).to_f / 60 / 60).round(3)
    end
  end
end

module Cmor::TimeTracking
  class Item < ApplicationRecord
    include AASM

    belongs_to :owner, class_name: Cmor::TimeTracking::Configuration.item_owner_class.call.name
    belongs_to :issue, optional: true
    has_one :project, through: :issue

    validates :start_at, presence: true

    scope :in_month, ->(date) { where(start_at: date.beginning_of_month..date.end_of_month) }
    scope :in_this_month, -> { in_month(Time.zone.now) }

    def external_project_identifier
      external_issue_identifier&.split("-")&.first
    end

    def external_issue
      return nil if external_issue_identifier.blank?
      @external_issue ||= Cmor::TimeTracking::ExternalIssue.find(external_issue_identifier)
    end

    aasm(:billing_state, column: "billing_state") do
      # items are draft by default. Changes to draft items are allowed.
      state :draft, initial: true

      # items are confirmed by the owner. Changes to confirmed items are not allowed.
      state :confirmed

      # items are confirmed by the owner. Changes to confirmed items are not allowed.
      state :billable

      # items are not billable. Changes to not billable items are allowed.
      state :not_billable

      # items are billed by the accounting department. Changes to billed items are not allowed.
      state :billed

      event :mark_as_confirmed do
        transitions from: :draft, to: :confirmed
      end

      # marks the item as confirmed so it can be billed
      #
      # This should be called by the owner of the item.
      event :mark_as_billable do
        transitions from: :confirmed, to: :billable
      end

      # marks the item as not billable
      #
      # This should be called by the owner of the item or the accounting department.
      event :mark_as_not_billable do
        transitions from: [:confirmed, :billable], to: :not_billable
      end

      # marks the item as billed
      #
      # This should be called by the accounting department.
      event :mark_as_billed do
        transitions from: :billable, to: :billed
      end

      # marks the item as draft
      #
      # This should be called by the owner of the item or the accounting department.
      event :mark_as_draft do
        transitions from: [:confirmed, :billable], to: :draft
      end
    end

    module DurationConcern
      extend ActiveSupport::Concern

      included do
        before_save :set_duration, if: -> { start_at_changed? || end_at_changed? }
      end

      def duration_in_hours
        (duration.to_f / 1.hour).round(3)
      end

      def duration_in_minutes
        duration / 1.minute
      end

      private

      def set_duration
        self.duration = (end_at - start_at).to_i
      end
    end

    include DurationConcern

    module YearAndMonthConcern
      extend ActiveSupport::Concern

      included do
        before_save :set_year_and_month, if: -> { start_at_changed? }
      end

      private

      def set_year_and_month
        self.year = start_at.year.to_s
        self.month = start_at.month.to_s
      end
    end

    include YearAndMonthConcern

    module DependenciesConcern
      extend ActiveSupport::Concern

      included do
        after_commit :create_dependencies, on: :create
      end

      private

      def create_dependencies
        Cmor::TimeTracking::CreateItemDependenciesService.call_later!(item: self)
      end
    end

    include DependenciesConcern
  end
end

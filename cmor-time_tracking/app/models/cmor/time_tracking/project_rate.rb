module Cmor::TimeTracking
  class ProjectRate < ApplicationRecord
    belongs_to :project
    belongs_to :rate

    validates :active_from, presence: true
    validates :active_to, presence: true
    validates :identifier, presence: true
    validates :identifier, uniqueness: {scope: [:project_id]}, if: -> { active }

    delegate :identifier, to: :rate, prefix: true

    before_validation :set_identifier

    def human
      rate.human
    end

    private

    def set_identifier
      self.identifier ||= rate&.identifier
    end

    module ActiveConcern
      extend ActiveSupport::Concern

      included do
        after_initialize :set_active_defaults

        scope :active_at, ->(point_in_time) { where("active_from <= ? AND active_to >= ?", point_in_time, point_in_time) }
        scope :active_now, -> { active_at(Time.zone.now) }
      end

      def active
        active_at(Time.zone.now)
      end

      def active_at(point_in_time)
        active_from&.<=(point_in_time) && active_to&.>=(point_in_time)
      end

      private

      def set_active_defaults
        self.active_from ||= Time.zone.at(0)
        self.active_to ||= Time.zone.parse("9999-12-31 23:59:59")
      end
    end

    include ActiveConcern
  end
end

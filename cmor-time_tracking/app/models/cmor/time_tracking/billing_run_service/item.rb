module Cmor
  module TimeTracking
    class BillingRunService::Item
      extend ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::AttributeAssignment

      attribute :item
      attribute :selected, :boolean, default: false
      attribute :project_rate

      delegate :billable?, :description, :duration_in_hours, :end_at, :human, :id, :mark_as_billed!, :month, :owner, :start_at, :year, to: :item
      delegate :identifier, to: :issue, prefix: true
      delegate :rate, to: :project_rate

      def initialize(attrs = {})
        @attributes = self.class._default_attributes.deep_dup
        assign_attributes(attrs)
      end

      def project
        issue&.project
      end

      def issue
        item&.issue
      end

      def project_rate
        @project_rate ||= project.current_default_rate
      end

      def project_rate_id
        project_rate&.id
      end
    end
  end
end

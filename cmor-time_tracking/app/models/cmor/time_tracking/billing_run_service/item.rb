module Cmor
  module TimeTracking
    class BillingRunService::Item
      extend ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::AttributeAssignment
      include ActiveModel::Validations

      attribute :item
      attribute :selected, :boolean, default: false
      attribute :project_rate
      attribute :invoice_owner

      delegate :billable?, :description, :duration_in_hours, :end_at, :human, :id, :mark_as_billed!, :month, :owner, :start_at, :year, to: :item
      delegate :identifier, to: :issue, prefix: true
      delegate :rate, to: :project_rate

      validates :item, presence: true
      validates :selected, inclusion: {in: [true, false]}
      validates :project, presence: true
      validates :project_rate, presence: true
      validates :issue_identifier, presence: true
      validates :invoice_owner_gid, presence: true

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

      def issue_identifier
        issue&.identifier
      end

      def project_rate
        @project_rate ||= project&.current_default_rate
      end

      def project_rate_id
        project_rate&.id
      end

      def invoice_owner
        @invoice_owner || project&.owner
      end

      def invoice_owner_gid
        # (invoice_owner || project&.owner)&.to_global_id
        invoice_owner&.to_global_id
      end

      def invoice_owner_gid=(value)
        self.invoice_owner = GlobalID::Locator.locate(value)
      end
    end
  end
end

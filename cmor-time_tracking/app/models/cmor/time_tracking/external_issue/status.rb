module Cmor
  module TimeTracking
    class ExternalIssue::Status < Rao::ActiveCollection::Base
      attr_accessor :description, :icon_url, :id, :name, :status_category, :url

      def status_category=(value)
        value["url"] = value.delete("self")
        @status_category = Cmor::TimeTracking::ExternalIssue::StatusCategory.new(value)
      end
    end
  end
end

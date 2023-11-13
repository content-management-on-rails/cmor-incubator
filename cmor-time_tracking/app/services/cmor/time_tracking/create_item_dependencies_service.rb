module Cmor
  module TimeTracking
    class CreateItemDependenciesService < Rao::Service::Base
      class Result < Rao::Service::Result::Base
        attr_accessor :project, :issue
      end

      attr_accessor :item

      validates :item, presence: true
      validates :item_external_project_identifier, presence: true
      validates :item_external_issue_identifier, presence: true

      private

      def item_external_project_identifier
        item&.external_project_identifier
      end

      def item_external_issue_identifier
        item&.external_issue_identifier
      end

      def _perform
        @result.project = build_project
        @result.issue = build_issue(@result.project)
      end

      def build_project
        Cmor::TimeTracking::Project.where(identifier: item.external_project_identifier).first_or_initialize do |project|
          project.owner ||= build_project_owner
        end
      end

      def build_project_owner
        Cmor::TimeTracking::Configuration.default_project_owner.call
      end

      def build_issue(project)
        Cmor::TimeTracking::Issue.where(identifier: item.external_issue_identifier).first_or_initialize do |issue|
          issue.project = project
        end
      end

      def save
        ActiveRecord::Base.transaction do
          @result.project.save!
          @result.issue.save!
          @result.issue.items << item
        rescue ActiveRecord::RecordInvalid => e
          puts e.message
          raise e
        end
      end
    end
  end
end

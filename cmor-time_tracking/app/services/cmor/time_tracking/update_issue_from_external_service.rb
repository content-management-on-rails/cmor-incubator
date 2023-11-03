module Cmor
  module TimeTracking
    class UpdateIssueFromExternalService < Rao::Service::Base
      class Result < Rao::Service::Result::Base
        attr_accessor :diff, :issue

        def diff_html
          diff.map do |item|
            "<br />#{item[:attribute_name]}: #{item[:old_value].to_s.truncate(64)} -> #{item[:new_value].to_s.truncate(64)}"
          end.join
        end
      end

      attr_accessor :issue, :issue_id, :external_issue

      validates :issue, presence: true
      validates :external_issue, presence: true

      private

      def issue
        @issue ||= Cmor::TimeTracking::Issue.find(@issue_id)
      end

      def _perform
        @result.diff = update_issue_from_external!
        @result.issue = issue
      end

      def external_issue
        issue&.external_issue
      end

      def update_issue_from_external!
        @issue.assign_attributes(
          summary: external_issue.summary,
          description: external_issue.description,
          external_state: external_issue.status_name
        )
        generate_diff
      end

      def save
        issue.save!
      end

      def generate_diff
        [].tap do |diff|
          if issue.summary_changed?
            diff << {
              attribute_name: :summary,
              old_value: issue.summary_was,
              new_value: issue.summary
            }
          end

          if issue.description_changed?
            diff << {
              attribute_name: :description,
              old_value: issue.description_was,
              new_value: issue.description
            }
          end

          if issue.external_state_changed?
            diff << {
              attribute_name: :external_state,
              old_value: issue.external_state_was,
              new_value: issue.external_state
            }
          end
        end
      end
    end
  end
end

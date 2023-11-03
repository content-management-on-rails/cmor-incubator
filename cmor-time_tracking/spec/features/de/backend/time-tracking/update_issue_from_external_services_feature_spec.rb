require "rails_helper"

RSpec.describe "/de/backend/time-tracking/update_issue_from_external_services", type: :feature, vcr: true do
  before(:each) do
    allow(Cmor::Core::Settings).to receive(:get).with("cmor_time_tracking/external_issue.jira.integration_enabled").and_return(ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_BASE_URL"))
    allow(Cmor::Core::Settings).to receive(:get).with("cmor_time_tracking/external_issue.jira.base_url").and_return(ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_BASE_URL"))
    allow(Cmor::Core::Settings).to receive(:get).with("cmor_time_tracking/external_issue.jira.username").and_return(ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_USERNAME"))
    allow(Cmor::Core::Settings).to receive(:get).with("cmor_time_tracking/external_issue.jira.api_token").and_return(ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_API_TOKEN"))
  end

  let(:base_path) { "/de/backend/time-tracking/update_issue_from_external_services" }

  describe "basic usage" do
    let(:new_path) { "#{base_path}/new" }

    let(:issue) { create(:cmor_time_tracking_issue, identifier: "BGIT-1") }

    before(:each) { issue }

    describe "UI" do
      before(:each) do
        visit(new_path)
        select issue.human, from: "update_issue_from_external_service[issue_id]"
        find("input[type=submit]").click
      end

      it { expect(current_path).to eq(new_path) }
      it { expect(page.body).to have_text("Ticket von externem Service aktualisieren wurde ausgeführt.") }
    end
  end
end

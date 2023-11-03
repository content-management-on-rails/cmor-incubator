require "rails_helper"

RSpec.describe Cmor::TimeTracking::UpdateIssueFromExternalService, type: :service, vcr: true do
  before(:each) do
    allow(Cmor::Core::Settings).to receive(:get).with("cmor_time_tracking/external_issue.jira.integration_enabled").and_return(ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_BASE_URL"))
    allow(Cmor::Core::Settings).to receive(:get).with("cmor_time_tracking/external_issue.jira.base_url").and_return(ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_BASE_URL"))
    allow(Cmor::Core::Settings).to receive(:get).with("cmor_time_tracking/external_issue.jira.username").and_return(ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_USERNAME"))
    allow(Cmor::Core::Settings).to receive(:get).with("cmor_time_tracking/external_issue.jira.api_token").and_return(ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_API_TOKEN"))
  end

  describe "basic usage" do
    let(:issue) { create(:cmor_time_tracking_issue, identifier: "BGIT-1") }

    subject { described_class.new(issue: issue) }

    describe "result" do
      subject { described_class.call(issue: issue) }

      it { expect(subject).to be_a(Rao::Service::Result::Base) }
      it { expect(subject).to be_ok }
      it { expect(subject.errors.full_messages).to match_array([]) }
      it { expect(subject.diff).to be_a(Array) }
      it { expect(subject.diff.size).to eq(3) }
      it { expect(subject.diff.first).to eq({attribute_name: :summary, old_value: nil, new_value: "O365 Accounts bereinigen"}) }
    end
  end
end

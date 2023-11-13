require "rails_helper"

RSpec.describe Cmor::TimeTracking::CreateItemDependenciesService, type: :service do
  describe "basic usage" do
    let(:item) { build(:cmor_time_tracking_item, external_issue_identifier: "ABC-123") }
    let(:attributes) { {item: item} }
    let(:options) { {} }

    subject { described_class.new(attributes, options) }

    describe "result" do
      subject { described_class.call(attributes, options) }

      it { expect(subject).to be_a(Rao::Service::Result::Base) }
      it { expect(subject).to be_ok }
      it { expect(subject.errors.full_messages).to eq([]) }
    end

    describe "persistence changes" do
      subject { described_class.new(attributes, options) }

      it { expect { subject.perform! }.to change { Cmor::TimeTracking::Issue.count }.from(0).to(1) }
      it { expect { subject.perform! }.to change { Cmor::TimeTracking::Project.count }.from(0).to(1) }
      it { expect { subject.perform! }.to change { Cmor::TimeTracking::Issue.first&.items.to_a }.from([]).to([item]) }
    end
  end
end

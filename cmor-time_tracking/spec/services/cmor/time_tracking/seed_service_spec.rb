require "rails_helper"

RSpec.describe Cmor::TimeTracking::SeedService, type: :service do
  describe "basic usage" do
    subject { described_class.new }

    describe "result" do
      subject { described_class.new.perform }

      it { expect(subject).to be_a(described_class::Result) }
      it { expect(subject).to be_ok }
    end

    describe "persistence changes" do
      it { expect { subject.perform }.to change { User.count }.from(0).to(3) }
      it { expect { subject.perform }.to change { Cmor::TimeTracking::Item.count }.from(0).to(198) }
    end
  end
end

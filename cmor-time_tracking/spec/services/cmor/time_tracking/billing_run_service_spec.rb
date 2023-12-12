require "rails_helper"

RSpec.describe Cmor::TimeTracking::BillingRunService, type: :service do
  describe "basic usage" do
    let(:items) { create_list(:cmor_time_tracking_item, 3) }

    let(:attributes) { {items: items} }
    let(:options) { {} }

    subject { described_class.new(attributes, options) }

    describe "result" do
      subject { super().perform }

      it { expect(subject).to be_a(Rao::Service::Result::Base) }
      it { expect(subject).to be_ok }
      it { expect(subject.errors.full_messages).to match_array([]) }
    end
  end
end

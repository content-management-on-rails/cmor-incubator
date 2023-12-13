require "rails_helper"

RSpec.describe Cmor::TimeTracking::BillingRunService::Item, type: :model do
  it { expect(subject).to respond_to(:valid?) }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:item) }
    it { expect(subject).to validate_presence_of(:project_rate) }
    # it { expect(subject).to validate_inclusion_of(:selected).in_array([true, false]) }
  end
end

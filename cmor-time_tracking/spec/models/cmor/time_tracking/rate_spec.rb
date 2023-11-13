require "rails_helper"

module Cmor::TimeTracking
  RSpec.describe Rate, type: :model do
    describe "associations" do
      it { expect(subject).to have_many(:project_rates).dependent(:destroy) }
      it { expect(subject).to have_many(:projects).through(:project_rates) }
    end

    describe "validations" do
      it { expect(subject).to validate_presence_of(:identifier) }
      it { expect(subject).to validate_uniqueness_of(:identifier) }
      it { expect(subject).to validate_presence_of(:unit_name) }
      it { expect(subject).to validate_presence_of(:unit_net_amount_cents) }
      it { expect(subject).to validate_presence_of(:unit_tax_rate_percentage) }
    end

    describe "human" do
      it { expect(subject).to respond_to(:human) }
    end

    describe "unit_net_amount" do
      it { expect(subject).to respond_to(:unit_net_amount) }
    end
  end
end

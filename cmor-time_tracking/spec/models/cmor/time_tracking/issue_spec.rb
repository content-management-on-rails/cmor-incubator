require "rails_helper"

module Cmor::TimeTracking
  RSpec.describe Issue, type: :model do
    describe "associations" do
      it { expect(subject).to belong_to(:project) }
      it { expect(subject).to have_many(:items) }
    end

    describe "validations" do
      subject { build(:cmor_time_tracking_issue) }

      it { expect(subject).to validate_presence_of(:identifier) }
      it { expect(subject).to validate_uniqueness_of(:identifier).scoped_to(:project_id) }
    end

    describe "human" do
      it { expect(subject).to respond_to(:human) }
    end

    describe "items_count" do
      it { expect(subject).to respond_to(:items_count) }
    end
  end
end

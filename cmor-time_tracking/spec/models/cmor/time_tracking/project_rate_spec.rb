require "rails_helper"

module Cmor::TimeTracking
  RSpec.describe ProjectRate, type: :model do
    describe "associations" do
      it { expect(subject).to belong_to(:project) }
      it { expect(subject).to belong_to(:rate) }
    end

    describe "validations" do
      it { expect(subject).to validate_presence_of(:active_from) }
      it { expect(subject).to validate_presence_of(:active_to) }
    end
  end
end

require "rails_helper"

module Cmor::TimeTracking
  RSpec.describe Project, type: :model do
    describe "associations" do
      it { expect(subject).to have_many(:issues) }
      it { expect(subject).to have_many(:items).through(:issues) }
      it { expect(subject).to have_many(:project_rates).dependent(:destroy) }
      it { expect(subject).to have_many(:rates).through(:project_rates) }
    end

    describe "validations" do
      subject { build(:cmor_time_tracking_project) }

      it { expect(subject).to validate_presence_of(:identifier) }
      it { expect(subject).to validate_uniqueness_of(:identifier) }
    end

    describe "human" do
      it { expect(subject).to respond_to(:human) }
    end

    describe "issues_count" do
      it { expect(subject).to respond_to(:issues_count) }
    end

    describe "items_count" do
      it { expect(subject).to respond_to(:items_count) }
    end

    describe "hours" do
      it { expect(subject).to respond_to(:hours) }
    end

    describe "draft_hours" do
      it { expect(subject).to respond_to(:draft_hours) }
    end

    describe "confirmed_hours" do
      it { expect(subject).to respond_to(:confirmed_hours) }
    end

    describe "billable_hours" do
      it { expect(subject).to respond_to(:billable_hours) }
    end

    describe "billed_hours" do
      it { expect(subject).to respond_to(:billed_hours) }
    end

    describe "not_billable_hours" do
      it { expect(subject).to respond_to(:not_billable_hours) }
    end
  end
end

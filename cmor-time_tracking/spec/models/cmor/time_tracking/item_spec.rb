require "rails_helper"

module Cmor::TimeTracking
  RSpec.describe Item, type: :model do
    describe "associations" do
      it { expect(subject).to belong_to(:owner).class_name(Cmor::TimeTracking::Configuration.item_owner_class.call.name) }
      it { expect(subject).to belong_to(:issue).optional }
    end

    describe "validations" do
      it { expect(subject).to validate_presence_of(:start_at) }
    end

    describe "billing state" do
      subject { build(:cmor_time_tracking_item) }

      it { expect(subject).to respond_to(:draft?) }
      it { expect(subject).to respond_to(:confirmed?) }
      it { expect(subject).to respond_to(:billable?) }
      it { expect(subject).to respond_to(:billed?) }
      it { expect(subject).to respond_to(:flatrate?) }
    end

    describe "dependencies concern" do
      subject { build(:cmor_time_tracking_item, external_issue_identifier: "ABC-123") }

      describe "job enqueueing" do
        it { expect { subject.save! }.to enqueue_job(Rao::Service::Job) }
      end

      describe "with inline job execution" do
        include ActiveJob::TestHelper

        around(:each) do |example|
          perform_enqueued_jobs { example.run }
        end

        it { expect { subject.save! }.to change { Cmor::TimeTracking::Issue.count }.from(0).to(1) }
        it { expect { subject.save! }.to change { Cmor::TimeTracking::Project.count }.from(0).to(1) }
      end
    end

    describe "duration" do
      describe "with start_at and end_at" do
        subject { build(:cmor_time_tracking_item, start_at: 1.day.ago, end_at: 1.day.ago + 1.hour) }

        it { expect { subject.save! }.to change { subject.duration }.from(nil).to(1.hour) }
      end
    end

    describe "external_project_identifier" do
      describe "with external_issue_identifier" do
        subject { build(:cmor_time_tracking_item, external_issue_identifier: "ABC-123") }

        it { expect(subject.external_project_identifier).to eq("ABC") }
      end

      describe "without external_issue_identifier" do
        subject { build(:cmor_time_tracking_item, external_issue_identifier: nil) }

        it { expect(subject.external_project_identifier).to eq(nil) }
      end
    end

    describe "year" do
      describe "with start_at" do
        subject { build(:cmor_time_tracking_item, start_at: 1.year.ago) }

        it { expect { subject.save! }.to change { subject.year }.from(nil).to(1.year.ago.year.to_s) }
      end
    end

    describe "month" do
      describe "with start_at" do
        subject { build(:cmor_time_tracking_item, start_at: 1.year.ago) }

        it { expect { subject.save! }.to change { subject.month }.from(nil).to(1.year.ago.month.to_s) }
      end
    end
  end
end

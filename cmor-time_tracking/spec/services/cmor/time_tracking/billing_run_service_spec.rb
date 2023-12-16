require "rails_helper"

RSpec.describe Cmor::TimeTracking::BillingRunService, type: :service do
  describe "basic usage" do
    let(:rate) { create(:cmor_time_tracking_rate, identifier: :default) }
    let(:project) { create(:cmor_time_tracking_project) }
    let(:issue) { create(:cmor_time_tracking_issue, project: project, identifier: "ISS-42") }
    let(:items) {
      [
        create_list(:cmor_time_tracking_item, 3, billing_state: "billable", issue: issue),
        create_list(:cmor_time_tracking_item, 3, billing_state: "billable", issue: issue, start_at: 1.month.ago)
      ].flatten
    }

    before(:each) do
      project.rates << rate
    end

    describe "result" do
      let(:attributes) { {items: items} }
      let(:options) { {autosave: true} }

      subject { described_class.new(attributes, options).perform }

      it { expect(subject).to be_a(Rao::Service::Result::Base) }
      it { expect(subject).to be_ok }
      it { expect(subject.errors.full_messages).to match_array([]) }
    end

    describe "when billing monthly" do
      let(:attributes) { {items: items, bill_monthly: true} }
      let(:options) { {autosave: true} }

      subject { described_class.new(attributes, options) }

      describe "result" do
        subject { super().perform }

        it { expect(subject.invoices.size).to eq(2) }
        it { expect(subject.billed_items.size).to eq(6) }
      end

      describe "persistence changes" do
        let(:expected_invoice_count) { 2 }
        let(:expected_line_item_count) { 2 }

        it { expect { subject.perform }.to change { Bgit::Invoicing::Invoice.count }.by(expected_invoice_count) }
        it { expect { subject.perform }.to change { Bgit::Invoicing::LineItem.count }.by(expected_line_item_count) }
      end
    end

    describe "when not billing monthly" do
      let(:attributes) { {items: items, bill_monthly: false} }
      let(:options) { {autosave: true} }

      subject { described_class.new(attributes, options) }

      describe "result" do
        subject { super().perform }

        it { expect(subject.invoices.size).to eq(1) }
        it { expect(subject.billed_items.size).to eq(6) }
      end

      describe "persistence changes" do
        let(:expected_invoice_count) { 1 }
        let(:expected_line_item_count) { 1 }
        let(:expected_billed_item_count) { 6 }

        it { expect { subject.perform }.to change { Bgit::Invoicing::Invoice.count }.by(expected_invoice_count) }
        it { expect { subject.perform }.to change { Bgit::Invoicing::LineItem.count }.by(expected_line_item_count) }
        it { expect { subject.perform }.to change { Bgit::Invoicing::BilledItem.count }.by(expected_billed_item_count) }

        describe "created invoice" do
          it { expect(subject.perform.invoices.first).to be_a(Bgit::Invoicing::Invoice) }
          it { expect(subject.perform.invoices.first.shipping_date).to eq(items.map(&:start_at).min.beginning_of_month.to_date) }
          it { expect(subject.perform.invoices.first.shipping_end_date).to eq(items.map(&:start_at).max.end_of_month.to_date) }
        end
      end
    end
  end
end

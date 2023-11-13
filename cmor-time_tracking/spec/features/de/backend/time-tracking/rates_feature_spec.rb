require "rails_helper"

RSpec.describe "/de/backend/zeiterfassung/rates", type: :feature do
  let(:resource_class) { Cmor::TimeTracking::Rate }
  let(:resource) { create(:cmor_time_tracking_rate) }
  let(:resources) { create_list(:cmor_time_tracking_rate, 3) }

  describe "REST actions" do
    # List
    it {
      resources
      expect(subject).to implement_index_action(self)
    }

    # Create
    it {
      expect(subject).to implement_create_action(self)
        .for(resource_class)
        .within_form("#new_rate") {
          # fill the needed form inputs via capybara here
          #
          # Example:
          #
          #     select 'de', from: 'slider[locale]'
          #     fill_in 'slider[name]', with: 'My first slider'
          #     check 'slider[auto_start]'
          #     fill_in 'slider[interval]', with: '3'
          fill_in "rate[identifier]", with: "default"
          fill_in "rate[unit_name]", with: "Stunde"
          fill_in "rate[unit_net_amount]", with: 100
          fill_in "rate[unit_tax_rate_percentage]", with: 19
        }
        .increasing { resource_class.count }.by(1)
    }

    # Read
    it { expect(subject).to implement_show_action(self).for(resource) }

    # Update
    it {
      expect(subject).to implement_update_action(self)
        .for(resource)
        .within_form(".edit_rate") {
          # fill the needed form inputs via capybara here
          #
          # Example:
          #
          #     fill_in 'slider[name]', with: 'New name'
          fill_in "rate[description]", with: "Some new text"
        }
        .updating
        .from(resource.attributes)
        .to({"description" => "Some new text"}) # Example: .to({ 'name' => 'New name' })
    }

    # Delete
    it {
      expect(subject).to implement_delete_action(self)
        .for(resource)
        .reducing { resource_class.count }.by(1)
    }
  end
end

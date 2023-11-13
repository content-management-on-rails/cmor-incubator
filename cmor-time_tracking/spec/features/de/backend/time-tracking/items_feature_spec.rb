require "rails_helper"

RSpec.describe "/de/backend/zeiterfassung/items", type: :feature do
  let(:resource_class) { Cmor::TimeTracking::Item }
  let(:resource) { create(:cmor_time_tracking_item) }
  let(:resources) { create_list(:cmor_time_tracking_item, 3) }

  let(:owner) { create(Cmor::TimeTracking::Configuration.item_owner_factory_name.call) }

  describe "REST actions" do
    # List
    it {
      resources
      expect(subject).to implement_index_action(self)
    }

    # Create
    it {
      owner
      expect(subject).to implement_create_action(self)
        .for(resource_class)
        .within_form("#new_item") {
          # fill the needed form inputs via capybara here
          #
          # Example:
          #
          #     select 'de', from: 'slider[locale]'
          #     fill_in 'slider[name]', with: 'My first slider'
          #     check 'slider[auto_start]'
          #     fill_in 'slider[interval]', with: '3'
          select owner.human, from: "item[owner_id]"
          fill_in "item[start_at]", with: 1.day.ago.strftime("%Y-%m-%d %H:%M")
          fill_in "item[end_at]", with: (1.day.ago + 1.hour).strftime("%Y-%m-%d %H:%M")
        }
        .increasing { resource_class.count }.by(1)
    }

    # Read
    it { expect(subject).to implement_show_action(self).for(resource) }

    # Update
    it {
      expect(subject).to implement_update_action(self)
        .for(resource)
        .within_form(".edit_item") {
          # fill the needed form inputs via capybara here
          #
          # Example:
          #
          #     fill_in 'slider[name]', with: 'New name'
          fill_in "item[description]", with: "Some new text"
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

require "rails_helper"

RSpec.describe "/de/backend/zeiterfassung/projects", type: :feature do
  let(:resource_class) { Cmor::TimeTracking::Project }
  let(:resource) { create(:cmor_time_tracking_project) }
  let(:resources) { create_list(:cmor_time_tracking_project, 3) }

  let(:user) { create(:user) }

  describe "REST actions" do
    # List
    it {
      resources
      expect(subject).to implement_index_action(self)
    }

    # Create
    describe "Create", type: :system, js: true do
      it {
        user
        expect(subject).to implement_create_action(self)
          .for(resource_class)
          .within_form("body") {
            # fill the needed form inputs via capybara here
            #
            # Example:
            #
            #     select 'de', from: 'slider[locale]'
            #     fill_in 'slider[name]', with: 'My first slider'
            #     check 'slider[auto_start]'
            #     fill_in 'slider[interval]', with: '3'
            polymorphic_select(user, :human, from: "project[owner_id]")
            fill_in "project[identifier]", with: "FOO"
          }
          .increasing { resource_class.count }.by(1)
      }
    end

    # Read
    it { expect(subject).to implement_show_action(self).for(resource) }

    # Update
    it {
      expect(subject).to implement_update_action(self)
        .for(resource)
        .within_form(".edit_project") {
          # fill the needed form inputs via capybara here
          #
          # Example:
          #
          #     fill_in 'slider[name]', with: 'New name'
          fill_in "project[identifier]", with: "BAR"
        }
        .updating
        .from(resource.attributes)
        .to({"identifier" => "BAR"}) # Example: .to({ 'name' => 'New name' })
    }

    # Delete
    it {
      expect(subject).to implement_delete_action(self)
        .for(resource)
        .reducing { resource_class.count }.by(1)
    }
  end
end

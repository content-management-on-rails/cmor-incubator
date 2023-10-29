require "rails_helper"

RSpec.describe "/de/backend/time-tracking/issues", type: :feature do
  let(:resource_class) { Cmor::TimeTracking::Issue }
  let(:resource) { create(:cmor_time_tracking_issue) }
  let(:resources) { create_list(:cmor_time_tracking_issue, 3) }

  let(:project) { create(:cmor_time_tracking_project) }

  describe "REST actions" do
    # List
    it {
      resources
      expect(subject).to implement_index_action(self)
    }

    # Create
    it {
      project
      expect(subject).to implement_create_action(self)
        .for(resource_class)
        .within_form("#new_issue") {
          # fill the needed form inputs via capybara here
          #
          # Example:
          #
          #     select 'de', from: 'slider[locale]'
          #     fill_in 'slider[name]', with: 'My first slider'
          #     check 'slider[auto_start]'
          #     fill_in 'slider[interval]', with: '3'
          select project.human, from: "issue[project_id]"
          fill_in "issue[identifier]", with: "MYISSUE-123"
        }
        .increasing { resource_class.count }.by(1)
    }

    # Read
    it { expect(subject).to implement_show_action(self).for(resource) }

    # Update
    it {
      expect(subject).to implement_update_action(self)
        .for(resource)
        .within_form(".edit_issue") {
          # fill the needed form inputs via capybara here
          #
          # Example:
          #
          #     fill_in 'slider[name]', with: 'New name'
          fill_in "issue[summary]", with: "A new issue summary"
        }
        .updating
        .from(resource.attributes)
        .to({"summary" => "A new issue summary"}) # Example: .to({ 'name' => 'New name' })
    }

    # Delete
    it {
      expect(subject).to implement_delete_action(self)
        .for(resource)
        .reducing { resource_class.count }.by(1)
    }
  end
end

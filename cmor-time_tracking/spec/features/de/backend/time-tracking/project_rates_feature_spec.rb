require "rails_helper"

RSpec.describe "/de/backend/zeiterfassung/project_rates", type: :feature do
  let(:resource_class) { Cmor::TimeTracking::ProjectRate }
  let(:resource) { create(:cmor_time_tracking_project_rate) }
  let(:resources) { create_list(:cmor_time_tracking_project_rate, 3) }

  let(:project) { create(:cmor_time_tracking_project) }
  let(:rate) { create(:cmor_time_tracking_rate) }

  describe "REST actions" do
    # List
    it {
      resources
      expect(subject).to implement_index_action(self)
    }

    # Create
    it {
      project
      rate
      expect(subject).to implement_create_action(self)
        .for(resource_class)
        .within_form("#new_project_rate") {
          # fill the needed form inputs via capybara here
          #
          # Example:
          #
          #     select 'de', from: 'slider[locale]'
          #     fill_in 'slider[name]', with: 'My first slider'
          #     check 'slider[auto_start]'
          #     fill_in 'slider[interval]', with: '3'
          select project.human, from: "project_rate[project_id]"
          select rate.human, from: "project_rate[rate_id]"
          fill_in "project_rate[active_from]", with: 1.day.ago.strftime("%Y-%m-%d %H:%M")
          fill_in "project_rate[active_to]", with: 1.day.from_now.strftime("%Y-%m-%d %H:%M")
          fill_in "project_rate[identifier]", with: "default"
        }
        .increasing { resource_class.count }.by(1)
    }

    # Read
    it { expect(subject).to implement_show_action(self).for(resource) }

    # Update
    it {
      expect(subject).to implement_update_action(self)
        .for(resource)
        .within_form(".edit_project_rate") {
          # fill the needed form inputs via capybara here
          #
          # Example:
          #
          #     fill_in 'slider[name]', with: 'New name'
          fill_in "project_rate[active_to]", with: 2.days.from_now.strftime("%Y-%m-%d %H:%M")
        }
        .updating
        .from(resource.attributes)
        .to({"active_to" => 2.days.from_now.strftime("%Y-%m-%d %H:%M")}) # Example: .to({ 'name' => 'New name' })
    }

    # Delete
    it {
      expect(subject).to implement_delete_action(self)
        .for(resource)
        .reducing { resource_class.count }.by(1)
    }
  end
end

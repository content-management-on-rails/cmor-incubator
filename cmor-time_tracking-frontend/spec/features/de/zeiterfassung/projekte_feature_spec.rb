require "rails_helper"

RSpec.describe "/de/zeiterfassung/projekte", type: :feature do
  let(:resource_class) { Cmor::TimeTracking::Project }
  let(:resource) { create(:cmor_time_tracking_project, owner: user) }
  let(:resources) { create_list(:cmor_time_tracking_project, 3, owner: user) }

  let(:user) { create(:user) }

  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_frontend_auth_user).and_return(user)
    allow(Cmor::TimeTracking::Configuration).to receive(:project_owner_classes).and_return(-> { {User => main_app.url_for([:autocomplete, User])} })
  end

  describe "REST actions" do
    # List
    it {
      resources
      expect(subject).to implement_index_action(self)
    }

    # Read
    it { expect(subject).to implement_show_action(self).for(resource) }
  end
end

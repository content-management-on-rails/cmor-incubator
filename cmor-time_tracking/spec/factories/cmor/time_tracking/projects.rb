FactoryBot.define do
  factory :cmor_time_tracking_project, class: Cmor::TimeTracking::Project do
    association(:owner, factory: Cmor::TimeTracking::Configuration.project_owner_factory_name.call)
    sequence(:identifier) { |i| "project-#{i}" }
  end
end

FactoryBot.define do
  factory :cmor_time_tracking_project, class: Cmor::TimeTracking::Project do
    sequence(:identifier) { |i| "project-#{i}" }
  end
end

FactoryBot.define do
  factory :cmor_time_tracking_issue, class: Cmor::TimeTracking::Issue do
    association(:project, factory: :cmor_time_tracking_project)
    sequence(:identifier) { |i| "issue-#{i}" }
  end
end

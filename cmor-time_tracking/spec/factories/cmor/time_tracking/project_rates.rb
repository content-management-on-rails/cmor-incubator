FactoryBot.define do
  factory :cmor_time_tracking_project_rate, class: Cmor::TimeTracking::ProjectRate do
    association(:project, factory: :cmor_time_tracking_project)
    association(:rate, factory: :cmor_time_tracking_rate)
  end
end

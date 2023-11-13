FactoryBot.define do
  factory :cmor_time_tracking_project_rate, class: Cmor::TimeTracking::ProjectRate do
    association(:project, factory: :cmor_time_tracking_project)
    association(:rate, factory: :cmor_time_tracking_rate)
    active_from { 1.month.ago }
    active_to { 1.month.from_now }
  end
end

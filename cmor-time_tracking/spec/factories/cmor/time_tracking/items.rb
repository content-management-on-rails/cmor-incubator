FactoryBot.define do
  factory :cmor_time_tracking_item, class: Cmor::TimeTracking::Item do
    association(:owner, factory: Cmor::TimeTracking::Configuration.item_owner_factory_name.call)
    association(:issue, factory: :cmor_time_tracking_issue)
    start_at { 1.day.ago }
    end_at { 1.day.ago + 1.hour }
  end
end

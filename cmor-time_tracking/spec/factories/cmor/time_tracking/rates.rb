FactoryBot.define do
  factory :cmor_time_tracking_rate, class: Cmor::TimeTracking::Rate do
    sequence(:identifier) { |i| "rate-#{i}" }
    unit_name { "Stunde" }
    unit_net_amount_cents { 10000 }
    unit_tax_rate_percentage { 19 }
    description { "Standard Stundensatz" }
  end
end

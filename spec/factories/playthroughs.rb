FactoryBot.define do
  factory :playthrough do
    association :player
    sequence(:started_at) { |n| Time.current - n.days }
    score { BigDecimal("31.56") }
    time_spent { 3600.0 }
  end
end

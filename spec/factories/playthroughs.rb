FactoryBot.define do
  factory :playthrough do
    association :player
    started_at { 2.days.ago }
    finished_at { 1.day.ago }
    score { BigDecimal("31.56") }
    time_spent { 3600.0 }
  end
end

FactoryBot.define do
  factory :event do
    description { Faker::Lorem.sentence }
    event_type { Faker::Number.between(from: 1, to: 3) }
    occurred_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    user
    order
  end
end

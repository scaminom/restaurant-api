FactoryBot.define do
  factory :order do
    date { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    status { 'completed' }
    total { Faker::Commerce.price(range: 10..200.0) }
    table

    trait :with_waiter do
      association :waiter, factory: [:user, :waiter]
    end
  end
end

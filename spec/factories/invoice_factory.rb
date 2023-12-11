FactoryBot.define do
  factory :invoice do
    order_number { create(:order).order_number }
    payment_method { Faker::Number.between(from: 1, to: 3) }
    client
  end
end

FactoryBot.define do
  factory :invoice do
    order_number { create(:order, :with_waiter).order_number }
    payment_method { Faker::Number.between(from: 1, to: 3) }
    client { create(:client, id: '0504427758') }
  end
end

FactoryBot.define do
  factory :item do
    quantity { Faker::Number.between(from: 1, to: 10) }
    # unit_price { Faker::Commerce.price(range: 1..100.0) }
    # subtotal { Faker::Commerce.price(range: 10..200.0) }
    product
    association :order, factory: %i[order with_waiter]

    after(:create) do |item|
      item.update(unit_price: item.product.price) if item.unit_price.nil?
      item.set_unit_price_and_subtotal
      item.save!
    end
  end
end

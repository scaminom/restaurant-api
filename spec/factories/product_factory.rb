FactoryBot.define do
  factory :product do
    name { Faker::Food.unique.dish }
    description { Faker::Lorem.sentence }
    price { Faker::Commerce.price(range: 1..100.0) }
    category { %w[food drink].sample }
    image { Faker::Internet.url }
  end
end

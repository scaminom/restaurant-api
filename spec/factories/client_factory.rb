FactoryBot.define do
  factory :client do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    address { Faker::Address.full_address }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    date { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    id_type { Faker::Number.between(from: 1, to: 2) }
  end
end


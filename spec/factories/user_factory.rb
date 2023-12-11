FactoryBot.define do
  factory :user do
    username { Faker::Internet.user_name }
    password { Faker::Internet.password }
    email { Faker::Internet.email }
    encrypted_password { Devise.friendly_token }
    role { Faker::Number.between(from: 0, to: 4) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end

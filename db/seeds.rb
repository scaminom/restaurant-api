10.times do
  Product.create(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    price: Faker::Commerce.price(range: 1.00..1000.00),
    category: Faker::Number.between(from: 1, to: 2),
    image: Faker::Lorem.sentence
  )
end

10.times do
  User.create(
    username: Faker::Internet.user_name,
    password: Faker::Internet.password,
    email: Faker::Internet.email,
    encrypted_password: Devise.friendly_token,
    role: Faker::Number.between(from: 1, to: 3),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
  )
end

10.times do
  Table.create(
    status: %w[free occupied].sample,
    capacity: Faker::Number.between(from: 2, to: 10)
  )
end

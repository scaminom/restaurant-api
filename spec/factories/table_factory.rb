FactoryBot.define do
  factory :table do
    status { %w[free occupied].sample }
    capacity { Faker::Number.between(from: 2, to: 10) }
  end
end

class Product < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    name
    description
    price
    category
  ].freeze

  has_many :items

  enum category: {
    'food': 1,
    'drink': 2
  }
end

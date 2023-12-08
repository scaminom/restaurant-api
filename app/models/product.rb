class Product < ApplicationRecord
  has_many :items

  enum category: {
    'food': 1,
    'drink': 2
  }
end

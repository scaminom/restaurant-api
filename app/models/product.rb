class Product < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    name
    description
    price
    category
    image
  ].freeze

  validates_presence_of :name, :price, :category, :image
  validates :category, inclusion: { in: %w[food drink], message: 'is not a valid category' }

  has_many :items

  enum category: {
    'food': 1,
    'drink': 2
  }
end

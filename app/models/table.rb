class Table < ApplicationRecord
  has_one :order

  enum status: {
    'free': 1,
    'occupied': 2
  }
end

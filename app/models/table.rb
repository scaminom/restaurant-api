class Table < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    status
    capacity
  ].freeze

  has_one :order

  enum status: {
    'free': 1,
    'occupied': 2
  }
end

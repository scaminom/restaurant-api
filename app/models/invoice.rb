class Invoice < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    order_number
    payment_method
    client_id
  ].freeze

  belongs_to :client
  belongs_to :order, foreign_key: 'order_number', primary_key: 'order_number'

  enum payment_method: {
    'cash': 1,
    'transfer': 2,
    'online': 3
  }
end

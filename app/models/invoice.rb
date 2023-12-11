class Invoice < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    order_number
    payment_method
    client_id
  ].freeze

  validates_presence_of :order_number, :payment_method, :client_id

  belongs_to :client
  belongs_to :order, foreign_key: 'order_number', primary_key: 'order_number'

  validates :status, inclusion: { in: %w[cash transfer online], message: 'is not a valid payment_method' }

  enum payment_method: {
    'cash': 1,
    'transfer': 2,
    'online': 3
  }
end

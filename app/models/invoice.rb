class Invoice < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    order_number
    payment_method
    client_id
    voucher_number
  ].freeze

  validates_presence_of :order_number, :payment_method, :client_id

  belongs_to :client
  belongs_to :order, foreign_key: 'order_number', primary_key: 'order_number'

  validates :payment_method, inclusion: { in: %w[cash transfer online], message: 'is not a valid payment_method' }
  before_save :set_time, if: :new_record?

  enum payment_method: {
    'cash': 1,
    'transfer': 2,
    'online': 3
  }

  private

  def set_time
    self.date = Time.now
  end
end

class Item < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    quantity
    product_id
    order_number
  ].freeze

  validates_presence_of :quantity, :product_id, :order_number
  validates :status, inclusion: { in: %w[in_process dispatched], message: 'is not a valid status' }

  belongs_to :product
  belongs_to :order, foreign_key: 'order_number', primary_key: 'order_number'

  after_save :update_order_total
  before_validation :set_unit_price_and_subtotal

  enum status: {
    'in_process': 1,
    'dispatched': 2
  }

  private

  def update_order_total
    return unless order.present?

    order.calculate_total
  end

  def set_unit_price_and_subtotal
    self.unit_price = product.price if unit_price.nil?
    self.subtotal = quantity * unit_price if subtotal.nil?
  end
end

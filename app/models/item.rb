class Item < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    quantity
    product_id
    order_number
  ].freeze

  belongs_to :product
  belongs_to :order, foreign_key: 'order_number', primary_key: 'order_number'

  before_save :set_unit_price
  before_save :calculate_subtotal
  after_save  :update_order_total

  private

  def update_order_total
    return unless order.present?

    order.calculate_total
  end

  def calculate_subtotal
    self.subtotal = quantity * unit_price
  end

  def set_unit_price
    self.unit_price = product.price
  end
end

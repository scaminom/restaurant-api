class Order < ApplicationRecord
  WHITELISTED_ATTRIBUTES = [
    :status,
    :table_id,
    { items_attributes: %i[product_id quantity] }
  ].freeze

  validates_presence_of :status, :table_id
  validates :status, inclusion: { in: %w[ready in_process pending completed], message: 'is not a valid status' }

  belongs_to  :table
  belongs_to  :waiter, class_name: 'User', foreign_key: 'waiter_id'
  has_many    :items, foreign_key: 'order_number', primary_key: 'order_number'

  accepts_nested_attributes_for :items

  enum status: {
    'pending': 1,
    'in_process': 2,
    'ready': 3,
    'completed': 4
  }

  def calculate_total
    items.reload
    new_total = items.sum(&:subtotal)

    return if new_total == total

    update(total: new_total)
  end
end

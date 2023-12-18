class Order < ApplicationRecord
  WHITELISTED_ATTRIBUTES = [
    :status,
    :table_id,
    :waiter_id,
    { items: %i[product_id quantity] }
  ].freeze

  validates_presence_of :status, :waiter_id, :table_id
  validates :status, inclusion: { in: %w[in_process pending completed], message: 'is not a valid status' }

  belongs_to  :table
  belongs_to  :waiter, class_name: 'User', foreign_key: 'waiter_id'
  has_many    :items, foreign_key: 'order_number', primary_key: 'order_number'

  after_save  :set_table_status
  # after_update :handle_completion

  enum status: {
    'pending': 1,
    'in_process': 2,
    'completed': 3
  }

  def calculate_total
    items.reload
    new_total = items.sum(&:subtotal)

    return if new_total == total

    update(total: new_total)
  end

  def self.process_next_order
    next_order = Order.pending.order(:created_at).first
    next_order&.in_process!
  end

  private

  def set_table_status
    table.update(status: 2)
  end

  def handle_completion
    return unless completed?

    Order.process_next_order
  end
end

class Order < ApplicationRecord
  WHITELISTED_ATTRIBUTES = [
    :status,
    :table_id,
    :waiter_id,
    { items: %i[product_id quantity] }
  ].freeze

  validates_presence_of :status, :waiter_id, :table_id
  validates :status, inclusion: { in: %w[in_process ready completed], message: 'is not a valid status' }

  belongs_to  :table
  belongs_to  :waiter, class_name: 'User', foreign_key: 'waiter_id'
  has_many    :items, foreign_key: 'order_number', primary_key: 'order_number'

  before_save :set_date_time_now
  after_save  :set_table_status

  enum status: {
    'in_process': 1,
    'ready': 2,
    'completed': 3
  }, _default: 'in_process'

  def calculate_total
    items.reload
    new_total = items.sum(&:subtotal)

    return if new_total == total

    update(total: new_total)
  end

  def set_date_time_now
    self.date = Time.now
  end

  private

  def set_table_status
    table.update(status: 2)
  end
end

class Order < ApplicationRecord
  belongs_to  :table
  belongs_to  :waiter, class_name: 'User', foreign_key: 'waiter_id'
  has_many    :items, foreign_key: 'order_number', primary_key: 'order_number'
  before_save :set_date_time_now

  enum status: {
    'in_process': 1,
    'ready': 3,
    'completed': 4
  }

  def calculate_total
    new_total = items.sum(&:subtotal)

    return unless new_total != total

    update_column(:total, new_total)
  end

  def set_date_time_now
    self.date = Time.now
  end
end

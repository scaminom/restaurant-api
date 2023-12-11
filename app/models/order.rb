class Order < ApplicationRecord
  belongs_to  :table
  belongs_to  :waiter, class_name: 'User', foreign_key: 'waiter_id'
  has_many    :items, foreign_key: 'order_number', primary_key: 'order_number'
  before_save :set_date_time_now
  before_save :set_status
  after_save  :set_table_status
  after_save  :create_items

  
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

  def set_status
    self.status = 1
  end

  def set_table_status
    table.update(status: 2)
  end

  def create_items()
    self.items.each do |item|
      item.order_number = self.order_number
      item.save
    end
  end
  
end

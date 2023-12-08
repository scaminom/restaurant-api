class Order < ApplicationRecord
  belongs_to :table
  belongs_to :waiter, class_name: 'User', foreign_key: 'waiter_id'

  enum status: {
    'in_process': 1,
    'ready': 3,
    'completed': 4
  }
end

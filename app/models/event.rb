class Event < ApplicationRecord
  belongs_to :user
  belongs_to :order, foreign_key: 'order_number', primary_key: 'order_number'

  enum event_type: {
    'order_placed': 1,
    'item_ready': 2,
    'order_completed': 3
  }
end

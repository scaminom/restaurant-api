class Event < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    description
    event_type
    user_id
    order_number
  ].freeze

  belongs_to :user
  belongs_to :order, foreign_key: 'order_number', primary_key: 'order_number'

  enum event_type: {
    'order_placed': 1,
    'item_ready': 2,
    'order_completed': 3
  }
end

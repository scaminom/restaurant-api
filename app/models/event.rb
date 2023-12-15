class Event < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    description
    event_type
    user_id
    order_number
  ].freeze

  validates_presence_of :event_type, :user_id, :order_number

  belongs_to :user
  belongs_to :order, foreign_key: 'order_number', primary_key: 'order_number'

  validates :event_type,
            inclusion: { in: %w[order_placed item_ready order_completed], message: 'is not a valid order type' }

  before_save :set_occurred_at

  enum event_type: {
    'order_placed': 1,
    'item_ready': 2,
    'order_completed': 3
  }

  private

  def set_occurred_at
    self.occurred_at = Time.now
  end
end

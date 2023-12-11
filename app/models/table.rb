class Table < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    status
    capacity
  ].freeze

  has_one :order

  validate :validate_table_limit, on: :create

  enum status: {
    'free': 1,
    'occupied': 2
  }

  private

  def validate_table_limit
    return unless Table.count >= 7

    errors.add(:base, 'Maximum number of tables (7) reached. Cannot create more.')
  end
end

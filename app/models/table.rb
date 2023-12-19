class Table < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    id
    status
    capacity
  ].freeze

  validates_presence_of :status
  validate :validate_table_limit, on: :create
  validates :status, inclusion: { in: %w[free occupied], message: 'is not a valid status' }

  has_one :order

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

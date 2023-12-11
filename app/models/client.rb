class Client < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    id
    first_name
    last_name
    address
    email
    phone
    id_type
  ].freeze

  validates_presence_of :id, :first_name, :last_name, :address, :email, :phone, :id_type
  validates :id_type, inclusion: { in: %w[RUC CEDULA], message: 'is not a valid id' }

  before_save :set_date

  enum id_type: {
    'RUC': 1,
    'CEDULA': 2
  }

  private

  def set_date
    self.date = Time.now
  end
end

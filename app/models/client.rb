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
  has_many :invoices

  enum id_type: {
    'RUC': 1,
    'CEDULA': 2
  }
end

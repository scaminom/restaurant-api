class Client < ApplicationRecord
  WHITELISTED_ATTRIBUTES = %i[
    id
    first_name
    last_name
    address
    email
    phone
    date
    id_type
  ].freeze

  enum id_type: {
    'RUC': 1,
    'CEDULA': 2
  }
end

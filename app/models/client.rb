class Client < ApplicationRecord
  WHITELISTED_ATTRIBUTES = [
    :id,
    :first_name,
    :last_name,
    :address,
    :email,
    :phone,
    :date,
    :id_type
  ].frozen

  enum id_type: {
    'RUC': 1,
    'CEDULA': 2
  }
end

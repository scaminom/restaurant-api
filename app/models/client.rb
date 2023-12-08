class Client < ApplicationRecord
  enum id_type: {
    'RUC': 1,
    'CEDULA': 2
  }
end

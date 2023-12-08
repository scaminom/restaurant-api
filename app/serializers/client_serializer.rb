class ClientSerializer < Panko::Serializer
  attributes  :first_name,
              :last_name,
              :address,
              :email,
              :phone,
              :date,
              :id_type
end

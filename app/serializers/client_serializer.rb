class ClientSerializer < Panko::Serializer
  attributes  :id,
              :first_name,
              :last_name,
              :address,
              :email,
              :phone,
              :date,
              :id_type
end

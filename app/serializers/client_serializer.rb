class ClientSerializer < Panko::Serializer
  attributes  :id,
              :first_name,
              :last_name,
              :address,
              :email,
              :phone,
              :id_type
end

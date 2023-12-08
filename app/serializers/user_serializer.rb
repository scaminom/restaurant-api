class UserSerializer < Panko::Serializer
  attributes  :username,
              :email,
              :first_name,
              :last_name,
              :role
end

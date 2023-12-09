class EventSerializer < Panko::Serializer
  attributes  :description,
              :event_type,
              :ocurred_at

  has_one :user, serializer: UserSerializer, only: %i[username email]
  has_one :order, serializer: OrderSerializer, only: %i[status total]
end

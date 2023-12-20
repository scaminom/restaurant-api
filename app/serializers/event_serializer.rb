class EventSerializer < Panko::Serializer
  attributes  :description,
              :event_type,
              :occurred_at

  has_one :user, serializer: UserSerializer, only: %i[username email role]
  has_one :order, serializer: OrderSerializer, only: %i[order_number status total]
end

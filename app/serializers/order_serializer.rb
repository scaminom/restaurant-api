class OrderSerializer < Panko::Serializer
  attributes  :order_number,
              :date,
              :status,
              :total

  has_one :waiter, serializer: UserSerializer, only: %i[username email]
  has_one :table, serializer: TableSerializer
  has_many :items, each_serializer: ItemSerializer, only: %i[quantity subtotal]
end

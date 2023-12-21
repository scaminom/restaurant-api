class ItemSerializer < Panko::Serializer
  attributes  :id,
              :status,
              :quantity,
              :unit_price,
              :subtotal

  has_one :product, serializer: ProductSerializer, only: %i[name category]
end

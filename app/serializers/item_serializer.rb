class ItemSerializer < Panko::Serializer
  attributes  :id,
              :quantity,
              :unit_price,
              :subtotal

  has_one :product, serializer: ProductSerializer, only: %i[name]
end

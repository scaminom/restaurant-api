class ItemSerializer < Panko::Serializer
  attributes  :quantity,
              :unit_price,
              :subtotal,
              :product,
              :order

  def product
    object.product
  end

  def order
    object.order
  end
end

class ProductSerializer < Panko::Serializer
  attributes  :name,
              :description,
              :price,
              :category
end

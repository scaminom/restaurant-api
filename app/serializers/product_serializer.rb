class ProductSerializer < Panko::Serializer
  attributes  :id,
              :name,
              :description,
              :image,
              :price,
              :category
end

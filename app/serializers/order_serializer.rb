class OrderSerializer < Panko::Serializer
  attributes  :date,
              :status,
              :total,
              :waiter,
              :table

  def waiter
    object.user
  end

  def table
    object.table
  end
end

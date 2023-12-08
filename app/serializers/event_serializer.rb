class EventSerializer < Panko::Serializer
  attributes  :description,
              :event_type,
              :ocurred_at,
              :user,
              :order

  def order
    object.order
  end

  def user
    object.user
  end
end

module Listeners
  class CreateEventListener
    def order_created(order)
      Event.create(order_number: order.order_number, event_type: 'order_placed', user_id: order.waiter_id,
                   description: 'Order placed to prepare')
    end
  end
end

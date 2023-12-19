module Listeners
  class UpdateEventListener
    def order_created(order)
      Event.create(order_number: order.order_number, event_type: 'order_completed', user_id: order.waiter_id,
                   description: 'Order is ready to delivery')
      ActionCable.server.broadcast 'channel_name', message: 'order created'
    end
  end
end
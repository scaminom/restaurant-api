module Listeners
  class UpdateEventListener
    def order_created(order)
      Event.create(order_number: order.order_number, event_type: 'order_completed', user_id: order.waiter_id,
                   description: 'Order is ready to delivery')
    end

    def create_channel_order(_order)
      ActionCable.server.broadcast('orders_channel',
                                   'Order created')
    end
  end
end

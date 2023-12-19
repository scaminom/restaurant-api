module Listeners
  class UpdateEventListener
    def order_created(order)
      Event.create(order_number: order.order_number, event_type: 'order_completed', user_id: order.waiter_id,
                   description: 'Order is ready to delivery')
    end

    def create_channel_order(order)
      ActionCable.server.broadcast('orders_channel',
                                   "Order #{order.order_number} esta lista para entregar")
    end
  end
end

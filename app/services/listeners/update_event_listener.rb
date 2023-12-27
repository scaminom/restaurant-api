module Listeners
  class UpdateEventListener
    def order_in_process(order)
      Event.create(order_number: order.order_number, event_type: 'order_in_process', user_id: order.waiter_id,
                   description: 'The order is processing')
    end

    def order_modified(order)
      Event.create(order_number: order.order_number, event_type: 'order_modified', user_id: order.waiter_id,
                   description: 'The order was modify')
    end

    def order_ready(order)
      Event.create(order_number: order.order_number, event_type: 'order_ready', user_id: order.waiter_id,
                   description: 'Order is ready to delivery')
    end

    def create_channel_order_updated
      ActionCable.server.broadcast('orders_channel',
                                   'La orden fue actualizada')
    end

    def create_channel_order_in_process(order)
      ActionCable.server.broadcast("orders_channel_#{order.waiter.username}",
                                   "La orden #{order.order_number} esta en proceso")
    end

    def create_channel_order_ready(order)
      ActionCable.server.broadcast("orders_channel_#{order.waiter.username}",
                                   "La orden #{order.order_number} esta lista para entregar")
    end
  end
end

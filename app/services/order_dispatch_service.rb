class OrderDispatchService
  def initialize(order)
    @order = order
  end

  def dispatch_item(item_id)
    item = @order.items.find(item_id)
    item.update!(status: 'dispatched')
    broadcast_dispatched_item(item)
    check_order_completion
  end

  private

  def check_order_completion
    return unless @order.items.all? { |item| item.status == 'dispatched' }

    @order.update!(status: 'ready')
    OrderProcessingService.new(@order).process_order_on_ready
  end

  def broadcast_dispatched_item(item)
    ActionCable.server.broadcast(
      "orders_channel_#{item.order.waiter.username}",
      { message: "Item #{item.product.name} dispatched", item_id: item.id }
    )
  end
end

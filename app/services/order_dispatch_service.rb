class OrderDispatchService
  def initialize(order)
    @order = order
  end

  def dispatch_item(item_id)
    item = @order.items.find(item_id)
    item.update!(status: 'dispatched')
    broadcast_dispatched_item(item)

    if item.product.category == 'food'
      check_food_items_completion
    else
      check_order_completion
    end
  end

  private

  def check_food_items_completion
    return unless @order.items.joins(:product).where(products: { category: 'food' }).all? do |item|
                    item.status == 'dispatched'
                  end

    @order.update!(status: 'ready')
    OrderProcessingService.new(@order).process_order_on_ready
  end

  def check_order_completion
    return unless @order.items.all? { |item| item.status == 'dispatched' }

    @order.update!(status: 'dispatched')
  end

  def broadcast_dispatched_item(item)
    ActionCable.server.broadcast(
      "orders_channel_#{item.order.waiter.username}",
      { message: "El item #{item.product.name} esta listo para servir", item_id: item.id }
    )
  end
end

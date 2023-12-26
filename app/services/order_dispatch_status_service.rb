class OrderDispatchStatusService
  def initialize(order)
    @order = order
  end

  def dispatch_order_status
    @order.status = 'dispatched'
    @order
  end
end

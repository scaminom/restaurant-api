class InvoiceCreator
  def initialize(invoice_params)
    @invoice_params = invoice_params
  end

  def call
    @order_id = @invoice_params[:order_number]
    order = Order.find(@order_id)

    unless order.status == 'dispatched'
      raise StandardError,
            'The order has not been dispatched or has already been completed'
    end

    Invoice.transaction do
      update_order(order)

      invoice_params = build_invoice_params(order)
      Invoice.create(invoice_params.compact)
    end
  end

  private

  def update_order(order)
    order.status = 'completed'
    order.table.status = 'free' if order.table.status == 'occupied'
    order.table.save!
    order.save
  end

  def build_invoice_params(order)
    {
      order_number: order.id,
      payment_method: @invoice_params[:payment_method],
      client_id: @invoice_params[:client_id],
      voucher_number: @invoice_params[:voucher_number]
    }.merge(extra_invoice_params)
  end

  def extra_invoice_params
    @invoice_params[:payment_method] == 'transfer' ? { voucher_number: @invoice_params[:voucher_number] } : {}
  end
end

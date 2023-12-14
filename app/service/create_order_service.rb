class CreateOrderService
  def initialize(order_params)
    @order_params = order_params
  end

  def call
    Order.transaction do
      order = Order.create!(@order_params.except(:items))
      items_data = build_items_data(@order_params[:items], order)
      Item.insert_all!(items_data)
      order.calculate_total
      order
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Order creation failed: #{e.message}"
  end

  private

  def product_prices(items_params)
    Product.where(id: items_params.map { |item| item[:product_id] })
           .pluck(:id, :price).to_h
  end

  def build_items_data(items_params, order)
    price = product_prices(items_params)

    items_params.map do |item|
      unit_price = calculate_unit_price(price, item)
      subtotal = calculate_subtotal(item, unit_price)
      item.merge(
        order_number: order.order_number,
        unit_price:,
        subtotal:
      )
    end
  end

  def calculate_unit_price(product_prices, item)
    product_prices[item[:product_id]]
  end

  def calculate_subtotal(item, unit_price)
    item[:quantity] * unit_price
  end
end

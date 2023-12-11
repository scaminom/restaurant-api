class OrdersController < ApplicationController
  before_action :set_order, only: %i[show update destroy]

  def index
    orders = Order.all

    render json: Panko::ArraySerializer.new(
      orders, each_serializer: OrderSerializer
    ).to_json
  end

  def show
    render json: { event: order_serializer(@order) } if stale?(@order)
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      render json: { order: order_serializer(@order) }, status: :accepted
    else
      render json: @order.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      render json: { order: order_serializer(@order) }
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @order.destroy
      render json: { message: 'order deleted successfully' }
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(*Order::WHITELISTED_ATTRIBUTES)
  end

  def order_serializer(order)
    Rails.cache.fetch([cache_key(order), I18n.locale]) do
      OrderSerializer.new.serialize(order)
    rescue StandardError => e
      Rails.logger.error "Error serializing order #{order.id}: #{e.message}"
      {}.as_json
    end
  end

  def cache_key(order)
    "orders/#{order.id}"
  end
end

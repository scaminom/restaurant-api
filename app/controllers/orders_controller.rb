require_dependency '../services/post/create_order_whisper.rb'

class OrdersController < ApplicationController
  before_action :set_order, only: %i[show update destroy]

  def index
    orders = Order.all

    render json: Panko::ArraySerializer.new(
      orders, each_serializer: OrderSerializer
    ).to_json
  end

  def show
    render json: { order: order_serializer(@order) }
  end

  def create
    order_creator = OrderCreator.new(order_params)
    @order = order_creator.call

    if @order.save
      order_publisher = Services::Post::CreateOrderWhisper.new
      order_publisher.publish_order_creation(@order)
      order_publisher.subscribe(Listeners::CreateEventListener.new.order_created(@order))
      order_publisher.subscribe(Listeners::CreateEventListener.new.create_channel_order(@order))
      render json: { order: order_serializer(@order) }, status: :accepted
    else
      render json: @order.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      order_publisher = Services::Post::CreateOrderWhisper.new
      order_publisher.publish_order_creation(@order)
      order_publisher.subscribe(Listeners::UpdateEventListener.new.order_created(@order))
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

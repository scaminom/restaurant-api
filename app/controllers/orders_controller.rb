class OrdersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_order, only: %i[show update destroy in_process dispatch_item]

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
    order_creator = OrderCreator.new(order_params, current_user)
    @order = order_creator.call

    if @order.save
      OrderProcessingService.new(@order).process_order_on_create
      render json: { order: order_serializer(@order) }, status: :accepted
    else
      render json: @order.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      OrderProcessingService.new(@order).process_order_on_update
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

  def in_process
    @order.status = 'in_process'
    if @order.save
      OrderProcessingService.new(@order).process_order_in_process
      render json: { order: order_serializer(@order) }
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def dispatch_item
    OrderDispatchService.new(@order).dispatch_item(params[:item_id])
    render json: { order: order_serializer(@order) }
  end

  def dispatch_order
    result = OrderDispatchStatusService.new(@order).dispatch_order_status
    if result.save
      render json: { order: order_serializer(result) }
    else
      render json: { errors: result.errors.full_messages }, status: :unprocessable_entity
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

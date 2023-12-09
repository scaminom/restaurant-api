class ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]

  def index
    @items = Item.all

    raise ActiveRecord::RecordNotFound, 'No items found' if @items.empty?

    serialized_items = @items.map do |item|
      item_serializer(item)
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message, item_id: item.id }, status: :not_found
      next
    end

    render json: { items: serialized_items }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def show
    render json: { item: item_serializer(@item) } if stale?(@item)
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      render json: { item: item_serializer(@item) }, status: :accepted
    else
      render json: @item.errors.full_messages, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def update
    if @item.update(item_params)
      render json: { item: item_serializer(@item) }
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def destroy
    if @item.destroy
      render json: { message: 'Item deleted successfully' }
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_item
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def item_params
    params.require(:item).permit(:quantity, :product_id, :order_number)
  end

  def item_serializer(item)
    Rails.cache.fetch([cache_key(item), I18n.locale]) do
      ItemSerializer.new.serialize(item)
    rescue StandardError => e
      Rails.logger.error "Error serializing item #{item.id}: #{e.message}"
      {}.as_json
    end
  end

  def cache_key(item)
    "items/#{item.id}"
  end
end

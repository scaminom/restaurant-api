class ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]

  def index
    items = Item.all

    render json: Panko::ArraySerializer.new(
      items, each_serializer: ItemSerializer
    ).to_json
  end

  def show
    render json: { item: item_serializer(@item) }
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      render json: { item: item_serializer(@item) }, status: :accepted
    else
      render json: @item.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      render json: { item: item_serializer(@item) }
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @item.destroy
      render json: { message: 'Item deleted successfully' }
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(*Item::WHITELISTED_ATTRIBUTES)
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

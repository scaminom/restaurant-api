class ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]

  def index
    products = Product.all

    render json: Panko::ArraySerializer.new(
      products, each_serializer: ProductSerializer
    ).to_json
  end

  def show
    render json: { product: product_serializer(@product) }
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      render json: { product: product_serializer(@product) }, status: :accepted
    else
      render json: @product.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: { product: product_serializer(@product) }
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      render json: { message: 'Product deleted successfully' }
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(*Product::WHITELISTED_ATTRIBUTES)
  end

  def product_serializer(product)
    Rails.cache.fetch([cache_key(product), I18n.locale]) do
      ProductSerializer.new.serialize(product)
    rescue StandardError => e
      Rails.logger.error "Error serializing product #{product.id}: #{e.message}"
      return {}.as_json
    end
  end

  def cache_key(product)
    "products/#{product.id}"
  end
end

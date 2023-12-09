class ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]

  def index
    @products = Product.all

    raise ActiveRecord::RecordNotFound, 'No product found' if @products.empty?

    serialized_products = @products.map do |product|
      product_serializer(product)
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message, product_id: product.id }, status: :not_found
      next
    end

    render json: { products: serialized_products }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def show
    render json: { product: product_serializer(@product) } if stale?(@product)
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      render json: { product: product_serializer(@product) }
    else
      render json: @product.errors.full_messages, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def update
    if @product.update(product_params)
      render json: { product: product_serializer(@product) }
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def destroy
    if @product.destroy
      render json: { message: 'Product deleted successfully' }
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :category)
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

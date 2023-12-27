class CooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.where(status: %i[pending in_process ready]).order(:created_at)
    authorize! :read, Order

    render json: Panko::ArraySerializer.new(
      @orders, each_serializer: OrderSerializer
    ).to_json
  end
end

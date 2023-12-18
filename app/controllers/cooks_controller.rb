class CooksController < ApplicationController
  def index
    @orders = Order.where(status: %i[pending in_process]).order(:created_at)

    render json: Panko::ArraySerializer.new(
      @orders, each_serializer: OrderSerializer
    ).to_json
  end
end

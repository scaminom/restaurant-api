class WaitersController < ApplicationController
  def new_order
    # Logic for creating a new order
  end

  def index
    @orders = Order.where(waiter: current_user).order(created_at: :desc)

    render json: Panko::ArraySerializer.new(
      @orders, each_serializer: OrderSerializer
    ).to_json
  end
end

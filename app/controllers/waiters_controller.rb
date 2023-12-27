class WaitersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.where(waiter: current_user).order(created_at: :desc)
    authorize! :read, Order

    render json: Panko::ArraySerializer.new(
      @orders, each_serializer: OrderSerializer
    ).to_json
  end
end

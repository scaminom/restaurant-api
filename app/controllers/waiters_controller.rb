class WaitersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @orders = Order.where(waiter: current_user).order(created_at: :desc)

    render json: Panko::ArraySerializer.new(
      @orders, each_serializer: OrderSerializer
    ).to_json
  end
end

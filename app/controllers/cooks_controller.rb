class CooksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @orders = Order.where(status: %i[pending in_process ready]).order(:created_at)

    render json: Panko::ArraySerializer.new(
      @orders, each_serializer: OrderSerializer
    ).to_json
  end
end

class AuditsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :read, :audits
    render json: {
      most_attended_waiter: user_info(most_attended_waiter),
      most_sold_product: product_info(most_sold_product)
    }
  end

  private

  def user_info(user)
    {
      username: user.username,
      first_name: user.first_name,
      last_name: user.last_name
    }
  end

  def product_info(product)
    {
      name: product.name
    }
  end

  def most_attended_waiter
    waiter_id = Event.select('user_id, COUNT(*) as order_count')
                     .where(event_type: 1)
                     .group(:user_id)
                     .order('order_count DESC')
                     .limit(1)
                     .first
                     &.user_id
    User.find(waiter_id)
  end

  def most_sold_product
    product_id = Item.joins('JOIN events ON items.order_number = events.order_number')
                     .select('items.product_id, COUNT(*) as frequency')
                     .group('items.product_id')
                     .order('frequency DESC')
                     .limit(1)
                     .first
                     &.product_id
    Product.find(product_id)
  end
end

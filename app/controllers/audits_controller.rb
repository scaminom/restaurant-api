class AuditsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :read, :audits
    render json: {
      most_attended_waiter: user_info(most_attended_waiter),
      most_sold_product: product_info(most_sold_product),
      total_revenue_by_waiter:,
      average_order_value:,
      frequent_clients:,
      product_category_performance:,
      sales_over_year:
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

  def total_revenue_by_waiter
    User.joins(:orders)
        .where(orders: { waiter_id: User.select(:id).where(role: User.roles['waiter']) })
        .select('users.id, users.username, SUM(items.subtotal) as total_revenue')
        .joins(orders: :items)
        .group('users.id')
        .order('total_revenue DESC')
        .map do |user|
          {
            username: user.username,
            total_revenue: user.total_revenue
          }
        end
  end

  def average_order_value
    Order.average(:total)
  end

  def frequent_clients
    Client.joins(:invoices)
          .select('clients.id, clients.first_name, clients.last_name, COUNT(invoices.invoice_number) as invoice_count')
          .group('clients.id, clients.first_name, clients.last_name')
          .order('invoice_count DESC')
          .limit(5)
          .map do |client|
            {
              first_name: client.first_name,
              last_name: client.last_name,
              invoice_count: client.invoice_count
            }
          end
  end

  def product_category_performance
    Product.joins(:items)
           .select('products.category, SUM(items.subtotal) as total_sales')
           .group('products.category')
           .order('total_sales DESC')
           .map do |product|
             {
               category: product.category,
               total_sales: product.total_sales
             }
           end
  end

  def sales_over_year
    Order.group_by_month(:created_at, last: 12).sum(:total)
  end
end

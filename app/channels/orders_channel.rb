class OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'orders_channel'
    stream_from "orders_channel_#{params[:waiter_username]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

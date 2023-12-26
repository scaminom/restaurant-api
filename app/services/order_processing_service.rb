require_dependency '../services/post/create_order_whisper.rb'

class OrderProcessingService
  def initialize(order)
    @order = order
  end

  def process_order_on_create
    order_publisher = Services::Post::CreateOrderWhisper.new
    create_event_listener = Listeners::CreateEventListener.new
    order_publisher.publish_order_creation(@order)
    order_publisher.subscribe(create_event_listener.order_created(@order))
    order_publisher.subscribe(create_event_listener.create_channel_order(@order))
  end

  def process_order_on_update
    order_publisher = Services::Post::CreateOrderWhisper.new
    update_event_listener = Listeners::UpdateEventListener.new
    order_publisher.publish_order_creation(@order)
    order_publisher.subscribe(update_event_listener.order_modified(@order))
    order_publisher.subscribe(update_event_listener.create_channel_order(@order))
  end

  def process_order_on_ready
    order_publisher = Services::Post::CreateOrderWhisper.new
    update_event_listener = Listeners::UpdateEventListener.new
    order_publisher.publish_order_creation(@order)
    order_publisher.subscribe(update_event_listener.order_ready(@order))
    order_publisher.subscribe(update_event_listener.create_channel_order_ready(@order))
  end

  def process_order_in_process
    order_publisher = Services::Post::CreateOrderWhisper.new
    update_event_listener = Listeners::UpdateEventListener.new
    order_publisher.publish_order_creation(@order)
    order_publisher.subscribe(update_event_listener.order_in_process(@order))
  end
end

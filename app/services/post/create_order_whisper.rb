module Services
  module Post
    class CreateOrderWhisper
      include Wisper::Publisher

      def publish_order_creation(order)
        broadcast('order_created', order)
      end
    end
  end
end

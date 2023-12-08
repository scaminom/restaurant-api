class InvoiceSerializer < Panko::Serializer
  attributes  :order,
              :payment_method,
              :client

  def order
    object.order
  end

  def client
    object.client
  end
end

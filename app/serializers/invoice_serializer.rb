class InvoiceSerializer < Panko::Serializer
  attributes  :order,
              :payment_method,
              :client

  has_one :client,  serializer: ClientSerializer
  has_one :order,   serializer: OrderSerializer
end

class InvoiceSerializer < Panko::Serializer
  attributes  :invoice_number,
              :payment_method

  has_one :client,  serializer: ClientSerializer
  has_one :order,   serializer: OrderSerializer
end

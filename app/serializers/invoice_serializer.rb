class InvoiceSerializer < Panko::Serializer
  attributes  :invoice_number,
              :date,
              :payment_method,
              :voucher_number

  has_one :client,  serializer: ClientSerializer
  has_one :order,   serializer: OrderSerializer
end

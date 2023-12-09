class Invoice < ApplicationRecord
  belongs_to :client
  belongs_to :order, foreign_key: 'order_number', primary_key: 'order_number'
end

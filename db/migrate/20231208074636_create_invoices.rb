class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices, id: false do |t|
      t.bigint :order_number
      t.bigserial :invoice_number, null: false, primary_key: true
      t.integer :payment_method
    end

    add_reference :invoices, :client, null: false, foreign_key: true, type: :string

    add_foreign_key :invoices, :orders, column: :order_number, primary_key: :order_number
  end
end


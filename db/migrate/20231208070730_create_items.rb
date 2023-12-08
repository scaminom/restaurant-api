class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.integer :quantity
      t.decimal :unit_price, precision: 8, scale: 3
      t.decimal :subtotal, precision: 10, scale: 2
      t.references :product, null: false, foreign_key: true
      t.bigint :order_number, null: false
    end

    add_foreign_key :items, :orders, column: :order_number, primary_key: :order_number
  end
end

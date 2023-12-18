class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders, id: false do |t|
      t.bigint      :order_number, null: false, primary_key: true
      t.integer     :status, default: 1
      t.decimal     :total
      t.references  :waiter, foreign_key: { to_table: :users, on_delete: :restrict }, index: true
      t.references  :table, null: false, foreign_key: true
      t.timestamps
    end
  end
end

class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :description
      t.integer :event_type
      t.datetime :occurred_at
      t.references :user, null: false, foreign_key: true
      t.bigint :order_number, null: false
    end

    add_foreign_key :events, :orders, column: :order_number, primary_key: :order_number
  end
end

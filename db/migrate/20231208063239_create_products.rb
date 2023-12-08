class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.decimal :price, precision: 8, scale: 3
      t.integer :category
    end
  end
end

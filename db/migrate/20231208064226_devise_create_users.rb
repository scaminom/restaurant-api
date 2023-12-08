# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string  :username,           null: false
      t.string  :email,              null: false, default: ''
      t.string  :encrypted_password, null: false, default: ''
      t.integer :role,               null: false, default: 0
      t.string  :first_name
      t.string  :last_name

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :username,             unique: true
  end
end

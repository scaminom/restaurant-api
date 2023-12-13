class AddJwtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :jti, :string, null: false
    add_index :users, :jti, name: 'index_users_on_jti', unique: true
  end
end

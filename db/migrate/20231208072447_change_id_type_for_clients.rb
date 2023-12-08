class ChangeIdTypeForClients < ActiveRecord::Migration[7.1]
  def up
    remove_column :clients, :id

    add_column :clients, :id, :string

    execute 'UPDATE clients SET id = CAST(id AS CHAR)'

    execute 'ALTER TABLE clients ADD PRIMARY KEY (id);'
  end

  def down
    remove_column :clients, :id
    add_column :clients, :id, :integer
    execute 'ALTER TABLE clients ADD PRIMARY KEY (id);'
  end
end

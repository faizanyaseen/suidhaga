class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :integer, default: 0
    add_column :users, :username, :string
    add_column :users, :phone, :string
    
    add_index :users, :username, unique: true
    add_index :users, :phone, unique: true
  end
end

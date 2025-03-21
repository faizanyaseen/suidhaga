class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :phone, null: false
      t.string :email
      t.text :address

      t.timestamps
    end
    
    add_index :customers, :phone, unique: true
    add_index :customers, :email, unique: true
  end
end 
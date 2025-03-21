class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :order_number, null: false
      t.decimal :total_price, precision: 10, scale: 2
      t.integer :status, default: 0
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end

    add_index :orders, :order_number, unique: true
  end
end

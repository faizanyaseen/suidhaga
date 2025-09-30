class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :plan_type, null: false, default: 'free'
      t.datetime :start_date, null: false
      t.datetime :end_date
      t.integer :status, default: 0
      t.integer :max_customers, default: 10
      t.integer :max_orders, default: 50
      t.text :features, default: '[]'
      t.decimal :price, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end

    add_index :subscriptions, [:user_id, :status]
    add_index :subscriptions, :end_date
  end
end

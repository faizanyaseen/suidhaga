class AddTailorToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :tailor, foreign_key: { to_table: :users }
  end
end

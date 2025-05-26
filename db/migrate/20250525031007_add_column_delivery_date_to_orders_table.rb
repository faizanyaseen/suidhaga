class AddColumnDeliveryDateToOrdersTable < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :delivery_date, :date
    add_column :orders, :received_at, :datetime
  end
end

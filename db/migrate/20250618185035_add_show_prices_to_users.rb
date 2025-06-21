class AddShowPricesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :show_prices, :boolean, default: true
  end
end

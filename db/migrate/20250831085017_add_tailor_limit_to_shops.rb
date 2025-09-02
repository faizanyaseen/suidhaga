class AddTailorLimitToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :tailor_limit, :integer, default: 0, null: false
  end
end

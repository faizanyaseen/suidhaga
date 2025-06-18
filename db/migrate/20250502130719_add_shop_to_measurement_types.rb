class AddShopToMeasurementTypes < ActiveRecord::Migration[8.0]
  def change
    add_reference :measurement_types, :shop, null: true, foreign_key: true
    add_index :measurement_types, [:shop_id, :key], unique: true, name: 'index_measurement_types_on_shop_id_and_key'
    remove_index :measurement_types, :key, if_exists: true
  end
end

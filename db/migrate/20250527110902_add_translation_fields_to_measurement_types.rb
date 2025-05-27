class AddTranslationFieldsToMeasurementTypes < ActiveRecord::Migration[8.0]
  def change
    rename_column :measurement_types, :key, :key_en
    add_column :measurement_types, :key_ur, :string

    remove_index :measurement_types, [:shop_id, :key_en] if index_exists?(:measurement_types, [:shop_id, :key_en])

    add_index :measurement_types, [:shop_id, :key_en], unique: true
    add_index :measurement_types, [:shop_id, :key_ur], unique: true
  end
end

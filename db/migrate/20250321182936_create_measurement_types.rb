class CreateMeasurementTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :measurement_types do |t|
      t.string :key, null: false
      t.float :value, null: false

      t.timestamps
    end

    add_index :measurement_types, :key, unique: true
  end
end

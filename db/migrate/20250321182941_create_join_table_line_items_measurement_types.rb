class CreateJoinTableLineItemsMeasurementTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :line_items_measurement_types do |t|
      t.references :line_item, null: false, foreign_key: true
      t.references :measurement_type, null: false, foreign_key: true
      t.float :value, null: false

      t.timestamps

      t.index [:line_item_id, :measurement_type_id], name: 'index_line_items_measurement_types'
    end
  end
end

class CreateCustomersMeasurementTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :customers_measurement_types do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :measurement_type, null: false, foreign_key: true
      t.float :value, null: false

      t.timestamps
    end

    add_index :customers_measurement_types, [:customer_id, :measurement_type_id], unique: true, name: 'index_customers_measurements_unique'
  end
end

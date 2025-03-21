class RemoveValueFromMeasurementTypes < ActiveRecord::Migration[8.0]
  def change
    remove_column :measurement_types, :value, :float
  end
end 
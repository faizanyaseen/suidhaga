class MeasurementType < ApplicationRecord
  has_many :line_items_measurement_types, dependent: :destroy
  has_many :line_items, through: :line_items_measurement_types

  validates :key, presence: true, uniqueness: true
end

class LineItemsMeasurementType < ApplicationRecord
  belongs_to :line_item
  belongs_to :measurement_type

  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }
end 
class MeasurementType < ApplicationRecord
  belongs_to :shop
  has_many :customers_measurement_types, dependent: :destroy
  has_many :customers, through: :customers_measurement_types

  has_many :line_items_measurement_types, dependent: :destroy
  has_many :line_items, through: :line_items_measurement_types

  validates :key, presence: true
  validates :key, uniqueness: { scope: :shop_id }
end

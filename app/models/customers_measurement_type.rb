class CustomersMeasurementType < ApplicationRecord
  belongs_to :customer
  belongs_to :measurement_type

  validates :value, presence: true, numericality: true
  validates :customer_id, uniqueness: { scope: :measurement_type_id }
end

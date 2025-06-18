class MeasurementType < ApplicationRecord
  belongs_to :shop
  has_many :customers_measurement_types, dependent: :destroy
  has_many :customers, through: :customers_measurement_types

  has_many :line_items_measurement_types, dependent: :destroy
  has_many :line_items, through: :line_items_measurement_types

  validates :key_en, presence: true, uniqueness: { scope: :shop_id }
  validates :key_ur, presence: true, uniqueness: { scope: :shop_id }

  scope :search, ->(query) {
    if query.present?
      where("key_en ILIKE :query OR key_ur ILIKE :query", query: "%#{query}%")
    else
      all
    end
  }

  def usage_count
    line_items_measurement_types.count + customers_measurement_types.count
  end

  def line_items_count
    line_items_measurement_types.count
  end

  def customers_count
    customers_measurement_types.count
  end

  def key
    I18n.locale == :ur ? key_ur : key_en
  end
end

class MeasurementType < ApplicationRecord
  belongs_to :shop
  has_many :customers_measurement_types, dependent: :destroy
  has_many :customers, through: :customers_measurement_types

  has_many :line_items_measurement_types, dependent: :destroy
  has_many :line_items, through: :line_items_measurement_types

  validates :key_en, uniqueness: { scope: :shop_id }, allow_blank: true
  validates :key_ur, uniqueness: { scope: :shop_id }, allow_blank: true
  validate :at_least_one_key_present

  before_save :auto_fill_empty_key

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

  private

  def at_least_one_key_present
    if key_en.blank? && key_ur.blank?
      errors.add(:base, I18n.t('measurement_types.errors.at_least_one_key_required'))
    end
  end

  def auto_fill_empty_key
    if key_en.present? && key_ur.blank?
      self.key_ur = key_en
    elsif key_ur.present? && key_en.blank?
      self.key_en = key_ur
    end
  end
end

class Customer < ApplicationRecord
  belongs_to :shop
  has_many :orders, dependent: :destroy

  has_many :customers_measurement_types, dependent: :destroy
  has_many :measurement_types, through: :customers_measurement_types

  accepts_nested_attributes_for :customers_measurement_types,
                               allow_destroy: true,
                               reject_if: proc { |attributes| attributes['measurement_type_id'].blank? }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true, uniqueness: true
  validates :email, uniqueness: true, allow_blank: true
  validates :shop, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end

class Shop < ApplicationRecord
  has_one_attached :logo
  has_many :measurement_types, dependent: :destroy
  has_many :users, dependent: :nullify
  has_many :tailors, -> { where(role: :tailor) }, class_name: 'User'
  has_one :owner, -> { where(role: :owner) }, class_name: 'User'
  has_many :customers, dependent: :destroy
  has_many :orders, through: :customers

  validates :name, presence: true
  validates :tailor_limit, numericality: { greater_than_or_equal_to: 0 }

  def tailor_limit_reached?
    tailors.count >= tailor_limit
  end

  def remaining_tailor_slots
    [tailor_limit - tailors.count, 0].max
  end
end

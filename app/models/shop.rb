class Shop < ApplicationRecord
  has_one_attached :logo
  has_many :measurement_types, dependent: :destroy
  has_many :users, dependent: :nullify
  has_many :tailors, -> { where(role: :tailor) }, class_name: 'User'
  has_one :owner, -> { where(role: :owner) }, class_name: 'User'
  has_many :customers, dependent: :destroy
  has_many :orders, through: :customers

  validates :name, presence: true
end

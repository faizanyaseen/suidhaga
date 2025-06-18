class Shop < ApplicationRecord
  has_many :measurement_types, dependent: :destroy
  has_many :users, dependent: :nullify
  has_many :customers, dependent: :destroy
  has_many :orders, through: :customers
  has_one_attached :logo
  
  validates :name, presence: true
end

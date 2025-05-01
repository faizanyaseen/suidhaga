class Shop < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :customers, dependent: :destroy
  has_many :orders, through: :customers
  
  validates :name, presence: true
end

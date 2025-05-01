class Customer < ApplicationRecord
  belongs_to :shop
  has_many :orders, dependent: :destroy
  
  validates :first_name, presence: true
  validates :phone, presence: true
  validates :shop, presence: true
end 
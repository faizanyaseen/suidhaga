class Customer < ApplicationRecord
  validates :first_name, presence: true
  validates :phone, presence: true
end 
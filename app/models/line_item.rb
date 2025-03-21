class LineItem < ApplicationRecord
  belongs_to :order
  has_many_attached :images
  has_many :line_items_measurement_types, dependent: :destroy
  has_many :measurement_types, through: :line_items_measurement_types

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :number_of_pieces, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # validate :check_measurement_types_attributes
  accepts_nested_attributes_for :line_items_measurement_types, allow_destroy: true, reject_if: :all_blank

  enum :status, {
    not_started: 0,
    in_progress: 1,
    completed: 2
  }, default: :not_started
end

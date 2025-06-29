class LineItem < ApplicationRecord
  belongs_to :order
  has_many_attached :images
  has_many :line_items_measurement_types, dependent: :destroy
  has_many :measurement_types, through: :line_items_measurement_types

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :number_of_pieces, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # validate :check_measurement_types_attributes
  accepts_nested_attributes_for :line_items_measurement_types, allow_destroy: true, reject_if: proc { |attributes| attributes['measurement_type_id'].blank? }

  enum :status, {
    not_started: 0,
    in_progress: 1,
    completed: 2,
    delivered: 3,
    cancelled: 4
  }, default: :not_started

  before_validation :set_default_status

  private

  def set_default_status
    self.status ||= :not_started
  end
end

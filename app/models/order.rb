class Order < ApplicationRecord
  belongs_to :customer
  has_many :line_items, dependent: :destroy
  has_one :shop, through: :customer

  enum :status, {
    received: 0,
    in_progress: 1,
    completed: 2,
    delivered: 3,
    pending: 4,
    cancelled: 5
  }, default: :received

  validates :order_number, presence: true, uniqueness: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true
  validates :customer, presence: true
  validate :must_have_line_items

  accepts_nested_attributes_for :line_items, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? }

  before_validation :generate_order_number, on: :create
  before_save :calculate_total_price
  before_validation :set_default_status

  def status_i18n
    I18n.t("orders.statuses.#{status}")
  end

  private

  def must_have_line_items
    if line_items.empty? || line_items.all? { |item| item.marked_for_destruction? }
      errors.add(:base, I18n.t('orders.errors.must_have_line_items'))
    end
  end

  def generate_order_number
    return if order_number.present?
    
    loop do
      # Generate a random order number with format ORD-YYYYMMDD-XXXX
      self.order_number = "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(2).upcase}"
      break unless Order.exists?(order_number: order_number)
    end
  end

  def calculate_total_price
    self.total_price = line_items.sum { |item| item.price * item.number_of_pieces }
  end

  def set_default_status
    self.status ||= 'received'
  end
end

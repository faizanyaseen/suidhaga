class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :tailor, class_name: 'User', optional: true
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
  validate :tailor_belongs_to_shop

  accepts_nested_attributes_for :line_items, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? }

  before_validation :generate_order_number, on: :create
  before_save :calculate_total_price
  before_validation :set_default_status
  before_save :update_active_status

  def status_i18n
    I18n.t("orders.statuses.#{status}")
  end

  default_scope { where(active: true) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :all_orders, -> { unscoped }

  private

  def update_active_status
    self.active = false if delivered? && status_changed?
  end

  def must_have_line_items
    if line_items.empty? || line_items.all? { |item| item.marked_for_destruction? }
      errors.add(:base, I18n.t('orders.errors.must_have_line_items'))
    end
  end

  def tailor_belongs_to_shop
    if tailor.present? && tailor.shop_id != customer.shop_id
      errors.add(:tailor, I18n.t('orders.errors.tailor_not_from_shop'))
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

# app/models/subscription.rb
class Subscription < ApplicationRecord
  belongs_to :user

  enum :status, {
    inactive: 0,
    active: 1
  }, default: :inactive

  enum :plan_type, {
    basic: 'basic',
    premium: 'premium'
  }, default: :basic

  validates :plan_type, presence: true
  validates :start_date, presence: true
  validates :max_customers, presence: true, numericality: { greater_than: 0 }
  validates :max_orders, presence: true, numericality: { greater_than: 0 }

  before_validation :set_defaults, on: :create

  scope :active, -> { where(status: :active) }
  scope :expired, -> { where('end_date < ?', Time.current) }

  def active?
    return false if end_date.nil?
    status == 'active' && Time.current <= end_date
  end

  def expired?
    return true if end_date.nil?
    Time.current > end_date
  end

  def remaining_days
    return 0 if end_date.nil? || expired?
    ((end_date - Time.current) / 1.day).ceil
  end

  def premium?
    plan_type == 'premium'
  end

  def basic?
    plan_type == 'basic'
  end

  def can_create_customer?
    return false unless active?
    return true if premium? # unlimited for premium
    user.shop.customers.count < max_customers
  end

  def can_create_order?
    return false unless active?
    return true if premium? # unlimited for premium
    user.shop.orders.count < max_orders
  end

  def customers_remaining
    return 0 unless active?
    return Float::INFINITY if premium? # unlimited for premium
    [max_customers - user.shop.customers.count, 0].max
  end

  def orders_remaining
    return 0 unless active?
    return Float::INFINITY if premium? # unlimited for premium
    [max_orders - user.shop.orders.count, 0].max
  end

  def usage_percentage_customers
    return 0 unless active?
    return 0 if premium? # no limit for premium
    (user.shop.customers.count.to_f / max_customers * 100).round(1)
  end

  def usage_percentage_orders
    return 0 unless active?
    return 0 if premium? # no limit for premium
    (user.shop.orders.count.to_f / max_orders * 100).round(1)
  end

  def deactivate!
    update!(status: :inactive)
  end

  def activate!
    update!(status: :active)
  end

  def upgrade_to_premium!
    update!(
      plan_type: :premium,
      max_customers: 999999, # Very high number to represent unlimited
      max_orders: 999999,
      price: 1000.0 # Set your premium price
    )
  end

  def downgrade_to_basic!
    update!(
      plan_type: :basic,
      max_customers: 10,
      max_orders: 50,
      price: 0.0
    )
  end

  private

  def set_defaults
    self.start_date ||= Time.current
    self.end_date ||= 1.month.from_now
    self.status ||= :active

    if plan_type == 'premium'
      self.max_customers ||= 999999
      self.max_orders ||= 999999
      self.price ||= 1000.0
    else # basic plan
      self.max_customers ||= 10
      self.max_orders ||= 50
      self.price ||= 0.0
    end
  end
end

# app/models/subscription.rb
class Subscription < ApplicationRecord
  belongs_to :user

  enum :status, {
    inactive: 0,
    active: 1
  }, default: :inactive

  enum :plan_type, {
    premium: 'premium'
  }, default: :premium

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
    true # Always premium
  end

  def can_create_customer?
    return false unless active?
    true # Always unlimited for premium
  end

  def can_create_order?
    return false unless active?
    true # Always unlimited for premium
  end

  def customers_remaining
    return 0 unless active?
    Float::INFINITY # Always unlimited for premium
  end

  def orders_remaining
    return 0 unless active?
    Float::INFINITY # Always unlimited for premium
  end

  def deactivate!
    update!(status: :inactive)
  end

  def activate!
    update!(status: :active)
  end

  private

  def set_defaults
    self.start_date ||= Time.current
    self.end_date ||= 1.month.from_now
    self.status = :inactive # Force inactive status
    self.plan_type ||= :premium
    self.max_customers ||= 999999
    self.max_orders ||= 999999
    self.price ||= 2500.0
  end
end

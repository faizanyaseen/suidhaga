class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  belongs_to :shop, optional: true
  has_one :subscription, dependent: :destroy
  
  attr_accessor :shop_name

  after_create :create_default_subscription

  def has_active_subscription?
    subscription&.active? || false
  end

  def can_create_customer?
    subscription&.can_create_customer? || false
  end

  def can_create_order?
    subscription&.can_create_order? || false
  end

  # Ensure subscription always exists
  def subscription
    super || create_default_subscription
  end

  private

  def create_default_subscription
    return self.subscription if self.subscription.present?

    self.create_subscription!(
      plan_type: 'basic',
      start_date: Time.current,
      end_date: 1.month.from_now,
      status: :active,
      max_customers: 10,
      max_orders: 50,
      price: 0.0
    )
  end
end

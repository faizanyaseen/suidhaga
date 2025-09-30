class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  belongs_to :shop, optional: true
  has_one :subscription, dependent: :destroy
  has_many :assigned_orders, class_name: 'Order', foreign_key: 'tailor_id', dependent: :nullify
  
  enum :role, { owner: 0, tailor: 1 }

  attr_accessor :shop_name

  validates :username, presence: true, uniqueness: true, if: :tailor?
  validates :phone, presence: true, uniqueness: true, if: :tailor?
  
  after_create :create_default_subscription

  # Skip password validation when password is not being changed
  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end

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
    # Check if subscription exists directly in database to avoid infinite loop
    existing_subscription = Subscription.find_by(user_id: id) if persisted?
    return existing_subscription if existing_subscription.present?

    self.create_subscription!(
      plan_type: 'premium',
      start_date: Time.current,
      end_date: 1.month.from_now,
      status: :inactive,
      max_customers: 999999,
      max_orders: 999999,
      price: 2500.0
    )
  end
end

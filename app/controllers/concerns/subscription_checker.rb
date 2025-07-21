# app/controllers/concerns/subscription_checker.rb
module SubscriptionChecker
  extend ActiveSupport::Concern

  included do
    before_action :check_subscription_for_creation, only: [:new, :create]
  end

  private

  def check_subscription_for_creation
    return unless %w[customers orders].include?(controller_name)

    unless current_user.has_active_subscription?
      redirect_to_subscription_required('subscription_expired')
      return
    end

    case controller_name
    when 'customers'
      unless current_user.can_create_customer?
        if current_user.subscription.basic?
          redirect_to_subscription_upgrade('customer_limit_reached',
            current: current_user.shop.customers.count,
            limit: current_user.subscription.max_customers)
        else
          redirect_to_subscription_required('customer_limit_reached')
        end
        return
      end
    when 'orders'
      unless current_user.can_create_order?
        if current_user.subscription.basic?
          redirect_to_subscription_upgrade('order_limit_reached',
            current: current_user.shop.orders.count,
            limit: current_user.subscription.max_orders)
        else
          redirect_to_subscription_required('order_limit_reached')
        end
        return
      end
    end
  end

  def redirect_to_subscription_required(reason, **options)
    flash[:error] = t("subscription.errors.#{reason}", **options)
    redirect_to root_path
  end

  def redirect_to_subscription_upgrade(reason, **options)
    flash[:warning] = t("subscription.upgrade_messages.#{reason}", **options)
    redirect_to subscription_path(current_user.subscription)
  end
end


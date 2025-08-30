# app/controllers/subscriptions_controller.rb
class SubscriptionsController < ApplicationController
  before_action :set_subscription

  def show
    # Show current subscription details
  end

  def edit
    # Show subscription upgrade options
  end

  def update
    if @subscription.update(subscription_params)
      redirect_to @subscription, notice: t('subscription.notices.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def upgrade
    # Handle subscription upgrade to premium
    if @subscription.upgrade_to_premium!
      redirect_to @subscription, notice: t('subscription.notices.upgraded_to_premium')
    else
      redirect_to @subscription, alert: t('subscription.errors.upgrade_failed')
    end
  end

  def downgrade
    # Handle downgrade to basic
    if @subscription.downgrade_to_basic!
      redirect_to @subscription, notice: t('subscription.notices.downgraded_to_basic')
    else
      redirect_to @subscription, alert: t('subscription.errors.downgrade_failed')
    end
  end

  def cancel
    if @subscription.deactivate!
      redirect_to @subscription, notice: t('subscription.notices.deactivated')
    else
      redirect_to @subscription, alert: t('subscription.errors.cancel_failed')
    end
  end

  private

  def set_subscription
    @subscription = current_user.subscription

    # Create subscription if it doesn't exist
    unless @subscription
      @subscription = current_user.create_subscription!(
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

  def subscription_params
    params.require(:subscription).permit(:plan_type, :max_customers, :max_orders)
  end
end

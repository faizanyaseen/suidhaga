class SubscriptionExpiryJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Starting subscription expiry check at #{Time.current}"

    # Find all active subscriptions that have expired
    expired_subscriptions = Subscription.where(
      status: :active
    ).where('end_date < ?', Time.current)

    expired_count = 0

    expired_subscriptions.find_each do |subscription|
      begin
        subscription.deactivate!
        expired_count += 1

        Rails.logger.info "Deactivated subscription #{subscription.id} for user #{subscription.user.email}"

        # Optionally send notification email to user about expiry
        # SubscriptionMailer.subscription_expired(subscription).deliver_now

      rescue => e
        Rails.logger.error "Failed to deactivate subscription #{subscription.id}: #{e.message}"
      end
    end

    Rails.logger.info "Subscription expiry check completed. #{expired_count} subscriptions deactivated."

    expired_count
  end
end
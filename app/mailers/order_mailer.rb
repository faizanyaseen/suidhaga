class OrderMailer < ApplicationMailer
  default from: 'no-reply@suidhaga.com'

  def order_completed(order)
    @order = order
    @customer = order.customer
    @shop = order.customer.shop
    
    # Set locale based on customer preference or default
    I18n.with_locale(I18n.default_locale) do
      mail(
        to: @customer.email,
        subject: t('order_mailer.order_completed.subject', order_number: @order.order_number, shop_name: @shop.name)
      )
    end
  end
end 
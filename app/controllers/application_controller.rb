class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Pagy::Backend
  before_action :authenticate_user!, :set_locale, :set_shop
  
  def current_shop
    current_user.shop if user_signed_in?
  end
  helper_method :current_shop

  private

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_shop
    @shop = Shop.first # or however you want to fetch the current shop
  end
end

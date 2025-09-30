class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Pagy::Backend
  
  before_action :authenticate_user!
  before_action :set_locale
  before_action :set_current_shop

  # Make current_shop available in views
  helper_method :current_shop
  helper_method :current_shop_logo

  protected

  def current_shop
    @current_shop ||= current_user&.shop
  end

  def current_shop_logo
    @current_shop_logo ||= current_shop&.logo if current_shop.present?
  end

  def set_current_shop
    @current_shop = current_shop
  end

  # Include current locale in all generated URLs
  def default_url_options
    { locale: I18n.locale }
  end

  private

  def set_locale
    I18n.locale = extract_locale || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale.to_s
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
end

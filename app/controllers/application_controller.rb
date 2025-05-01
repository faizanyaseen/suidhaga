class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Pagy::Backend
  before_action :authenticate_user!
  
  def current_shop
    current_user.shop if user_signed_in?
  end
  helper_method :current_shop
end

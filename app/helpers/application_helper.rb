module ApplicationHelper
  include Pagy::Frontend
  def show_prices?
    current_user&.show_prices == true
  end
end

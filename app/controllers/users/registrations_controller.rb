class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  
  def create
    build_resource(sign_up_params)
    
    shop_name = params[:user][:shop_name]
    shop = Shop.new(name: shop_name)
    
    if shop.save
      resource.shop = shop
    end
    
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
  
  protected
  
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:shop_name])
  end
end 
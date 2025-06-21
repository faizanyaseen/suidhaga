class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop

  def show
  end

  def update
    if current_user.update(user_params)
      respond_to do |format|
        format.html { redirect_to profiles_path, notice: t('profile.user.update_success') }
        format.json do
          render json: {
            status: :ok,
            message: t('profile.user.update_success'),
            html: {
              name: current_user.name,
              email: current_user.email
            }
          }
        end
      end
    else
      respond_to do |format|
        format.html { render :show }
        format.json { render json: { status: :error, message: current_user.errors.full_messages.join(', ') } }
      end
    end
  end

  def update_shop
    if @shop.update(shop_params)
      respond_to do |format|
        format.html { redirect_to profiles_path, notice: t('profile.shop.update_success') }
        format.json do
          response_data = {
            status: :ok,
            message: t('profile.shop.update_success'),
            html: {
              name: @shop.name
            }
          }
          
          # Only add logo_url if logo is attached
          if @shop.logo.attached?
            response_data[:html][:logo_url] = url_for(@shop.logo)
          end
          
          render json: response_data
        end
      end
    else
      respond_to do |format|
        format.html { render :show }
        format.json { render json: { status: :error, message: @shop.errors.full_messages.join(', ') } }
      end
    end
  end

  def toggle_price_visibility
    unless current_user.valid_password?(params[:password])
      redirect_to profiles_path, alert: "Invalid password. Could not update price visibility."
      return
    end
    # option = params[:show_prices] == "true"
    current_user.update(show_prices: params[:show_prices] == "true")
    redirect_to profiles_path, notice: "Price visibility updated successfully."
  end


  private

  def shop_params
    params.require(:shop).permit(:name, :logo)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

  def set_shop
    @shop = Shop.first # or however you fetch the current shop
  end
end 
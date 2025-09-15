class ProfilesController < ApplicationController
  include OwnerAuthorization
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
    shop_updated = @shop.update(shop_params)

    user_updated = true
    if params[:user] && params[:user][:password].present?
      if current_user.valid_password?(params[:user][:current_password])
        user_updated = current_user.update(password: params[:user][:password],
                                         password_confirmation: params[:user][:password_confirmation])
      else
        current_user.errors.add(:current_password, :invalid)
        user_updated = false
      end
    end

    if shop_updated && user_updated
      notice_message = if params[:user] && params[:user][:password].present? && user_updated
                         t('profile.update_with_password_success')
                       else
                         t('profile.shop.update_success')
                       end

      if params[:user] && params[:user][:password].present? && user_updated
        sign_out(current_user)
        redirect_to root_paths, notice: notice_message
        return
      end

      respond_to do |format|
        format.html { redirect_to profiles_path, notice: notice_message }
        format.json do
          response_data = {
            status: :ok,
            message: notice_message,
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
        format.json { render json: { status: :error, message: (@shop.errors.full_messages + current_user.errors.full_messages).join(', ') } }
      end
    end
  end

  def remove_logo
    @shop.logo.purge
    redirect_to profiles_path, notice: t('profile.shop.logo_removed')
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
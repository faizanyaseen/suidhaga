class TailorsController < ApplicationController
  include OwnerAuthorization
  
  before_action :authenticate_user!
  before_action :set_tailor, only: [:show, :edit, :update, :destroy]

  def index
    @tailors = current_shop.tailors
  end

  def show
  end

  def new
    @tailor = User.new
  end

  def create
    @tailor = User.new(tailor_params)
    @tailor.role = :tailor
    @tailor.shop = current_shop

    if @tailor.save
      redirect_to tailors_path, notice: t('tailors.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @tailor.update(tailor_update_params)
      redirect_to tailors_path, notice: t('tailors.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tailor.destroy
    redirect_to tailors_path, notice: t('tailors.deleted')
  end

  private

  def set_tailor
    @tailor = current_shop.tailors.find(params[:id])
  end

  def tailor_params
    params.require(:user).permit(:username, :phone, :email, :password, :password_confirmation)
  end
  
  def tailor_update_params
    update_params = params.require(:user).permit(:username, :phone, :email)
    
    # Only include password params if they are provided
    if params[:user][:password].present?
      update_params[:password] = params[:user][:password]
      update_params[:password_confirmation] = params[:user][:password_confirmation]
    end
    
    update_params
  end
end 
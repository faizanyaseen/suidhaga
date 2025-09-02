class TailorsController < ApplicationController
  include OwnerAuthorization
  
  before_action :authenticate_user!
  before_action :set_tailor, only: [:show, :edit, :update, :destroy]

  def index
    @tailors = current_shop.tailors
    @tailor_limit = current_shop.tailor_limit
    @remaining_slots = current_shop.remaining_tailor_slots
    @limit_reached = current_shop.tailor_limit_reached?
    
    # Calculate active orders count for each tailor
    @active_orders_count = {}
    @tailors.each do |tailor|
      @active_orders_count[tailor.id] = tailor.assigned_orders.where(active: true).count
    end
  end

  def show
    @orders = @tailor.assigned_orders.includes(:customer).order(created_at: :desc)
    @stats = calculate_tailor_stats(@tailor)
  end

  def new
    if current_shop.tailor_limit_reached?
      redirect_to tailors_path, alert: t('tailors.limit_reached', limit: current_shop.tailor_limit)
    else
      @tailor = User.new
      @remaining_slots = current_shop.remaining_tailor_slots
    end
  end

  def create
    if current_shop.tailor_limit_reached?
      redirect_to tailors_path, alert: t('tailors.limit_reached', limit: current_shop.tailor_limit)
      return
    end

    @tailor = User.new(tailor_params)
    @tailor.role = :tailor
    @tailor.shop = current_shop

    if @tailor.save
      redirect_to tailors_path, notice: t('tailors.created')
    else
      @remaining_slots = current_shop.remaining_tailor_slots
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

  def calculate_tailor_stats(tailor)
    orders = tailor.assigned_orders
    
    {
      total_orders: orders.count,
      pending_orders: orders.where(status: 'pending').count,
      in_progress_orders: orders.where(status: 'in_progress').count,
      completed_orders: orders.where(status: 'completed').count,
      delivered_orders: orders.where(status: 'delivered').count,
      late_orders: orders.where(
        'delivery_date < ? AND delivered_at IS NULL',
        Date.current
      ).where.not(status: 'cancelled').count,
      tomorrow_deliveries: orders.where(
        delivery_date: Date.tomorrow,
        status: ['pending', 'in_progress', 'ready']
      ).count,
      recent_orders: orders.order(created_at: :desc).limit(5)
    }
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
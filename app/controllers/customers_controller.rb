class CustomersController < ApplicationController
  include SubscriptionChecker

  before_action :set_customer, only: [:edit, :update, :show]
  before_action :set_measurement_types, only: [:new, :create, :edit, :update]

  def index
    @customers = current_shop.customers.order(created_at: :desc)
    
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @customers = @customers.where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ? OR phone ILIKE ?", 
                                  search_term, search_term, search_term, search_term)
    end
    
    @pagy, @customers = pagy(@customers, items: 10)
  end

  def new
    @customer = current_shop.customers.new
  end

  def edit
    @customer = current_shop.customers.find(params[:id])
    # Add some debugging
    Rails.logger.debug "Editing customer: #{@customer.id}"
  end

  def create
    @customer = current_shop.customers.new(customer_params)

    if @customer.save
      redirect_to customers_path, notice: 'Customer was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @customer.update(customer_params)
      redirect_to customers_path, notice: 'Customer was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def measurement_value
    @customer = Customer.find(params[:id])
    measurement_type_id = params[:measurement_type_id]

    measurement = @customer.customers_measurement_types.find_by(measurement_type_id: measurement_type_id)

    if measurement
      render json: { value: measurement.value }
    else
      render json: { value: nil }
    end
  end

  def show
    @orders = @customer.orders.includes(:line_items).order(created_at: :desc)
  end

  private

  def set_customer
    @customer = current_shop.customers.find(params[:id])
  end

  def set_measurement_types
    @measurement_types = current_shop.measurement_types
  end

  def customer_params
    params.require(:customer).permit(
      :first_name,
      :last_name,
      :phone,
      :email,
      :address,
      customers_measurement_types_attributes: [
        :id,
        :measurement_type_id,
        :value,
        :_destroy
      ]
    )
  end
end

class CustomersController < ApplicationController
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
    @customer = current_shop.customers.build
  end

  def create
    @customer = current_shop.customers.build(customer_params)
    
    if @customer.save
      redirect_to customers_path, notice: 'Customer was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :phone, :email, :address)
  end
end 
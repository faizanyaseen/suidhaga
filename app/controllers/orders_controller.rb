class OrdersController < ApplicationController
  def index
    @orders = Order.includes(:customer).order(created_at: :desc)
    
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @orders = @orders.joins(:customer)
                      .where("LOWER(orders.order_number) LIKE ? OR 
                             LOWER(customers.first_name) LIKE ? OR 
                             LOWER(customers.last_name) LIKE ? OR 
                             LOWER(customers.phone) LIKE ? OR 
                             LOWER(customers.email) LIKE ?", 
                             search_term, search_term, search_term, search_term, search_term)
    end

    @orders = @orders.page(params[:page]).per(10)
  end

  def show
    @order = Order.includes(:line_items, :customer).find(params[:id])
  end

  def new
    @order = Order.new
    @order.line_items.build
    @customers = Customer.all
    @measurement_types = MeasurementType.all
  end

  def create
    @order = Order.new(order_params)
    
    if @order.save
      redirect_to @order, notice: 'Order was successfully created.'
    else
      @customers = Customer.all
      @measurement_types = MeasurementType.all
      render :new, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :customer_id,
      :total_price,
      line_items_attributes: [
        :id,
        :price,
        :number_of_pieces,
        :_destroy,
        images: [],
        line_items_measurement_types_attributes: [:id, :measurement_type_id, :value, :_destroy]
      ]
    )
  end
end 
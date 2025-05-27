class MeasurementTypesController < ApplicationController
  before_action :set_measurement_type, only: [:show, :edit, :update, :destroy, :usage_info]

  def index
    @measurement_types = current_shop.measurement_types.order(:key)

    if params[:search].present?
      @measurement_types = @measurement_types.where("key ILIKE ?", "%#{params[:search]}%")
    end

    @measurement_types = @measurement_types.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @measurement_type = current_shop.measurement_types.build
  end

  def edit
  end

  def create
    @measurement_type = current_shop.measurement_types.build(measurement_type_params)

    if @measurement_type.save
      render json: { success: true, measurement_type: @measurement_type }
    else
      render json: { success: false, errors: @measurement_type.errors.full_messages }
    end
  end

  def update
    if @measurement_type.update(measurement_type_params)
      render json: { success: true, measurement_type: @measurement_type }
    else
      render json: { success: false, errors: @measurement_type.errors.full_messages }
    end
  end

  def usage_info
    render json: {
      line_items_count: @measurement_type.line_items_count,
      customers_count: @measurement_type.customers_count,
      total_count: @measurement_type.usage_count
    }
  end

  def destroy
    line_items_count = @measurement_type.line_items_count
    customers_count = @measurement_type.customers_count

    @measurement_type.destroy

    flash[:notice] = "Measurement type '#{@measurement_type.key}' was successfully deleted."
    if line_items_count > 0 || customers_count > 0
      flash[:notice] += " It was removed from #{line_items_count} line item(s) and #{customers_count} customer(s)."
    end

    redirect_to measurement_types_path
  end

  private
    def set_measurement_type
      @measurement_type = current_shop.measurement_types.find(params[:id])
    end

    def measurement_type_params
      params.require(:measurement_type).permit(:key)
    end
end

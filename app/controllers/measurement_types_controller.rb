class MeasurementTypesController < ApplicationController
  before_action :set_measurement_type, only: [:show, :edit, :update, :destroy]

  def index
    @measurement_types = current_shop.measurement_types.all
  end

  def show
  end

  def new
    @measurement_type = current_shop.measurement_types.new
  end

  def edit
  end

  def create
    @measurement_type = current_shop.measurement_types.new(measurement_type_params)

    if @measurement_type.save
      redirect_to measurement_types_path, notice: 'Measurement type was successfully created.'
    else
      render :new
    end
  end

  def update
    if @measurement_type.update(measurement_type_params)
      redirect_to measurement_types_path, notice: 'Measurement type was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @measurement_type.destroy
    redirect_to measurement_types_path, notice: 'Measurement type was successfully destroyed.'
  end

  private
    def set_measurement_type
      @measurement_type = current_shop.measurement_types.find(params[:id])
    end

    def measurement_type_params
      params.require(:measurement_type).permit(:key)
    end
end

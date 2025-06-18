class MeasurementTypesController < ApplicationController
  before_action :set_measurement_type, only: [:show, :edit, :update, :destroy, :usage_info]

  def index
    @measurement_types = current_shop.measurement_types
                                   .order(I18n.locale == :ur ? :key_ur : :key_en)
                                   .search(params[:search])

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
      errors = @measurement_type.errors.map do |error|
        if error.attribute == :key_en && error.type == :taken
          t('measurement_types.errors.key_en_taken')
        elsif error.attribute == :key_ur && error.type == :taken
          t('measurement_types.errors.key_ur_taken')
        else
          error.full_message
        end
      end
      render json: { success: false, errors: errors }
    end
  end

  def update
    if @measurement_type.update(measurement_type_params)
      render json: { success: true, measurement_type: @measurement_type }
    else
      errors = @measurement_type.errors.map do |error|
        if error.attribute == :key_en && error.type == :taken
          t('measurement_types.errors.key_en_taken')
        elsif error.attribute == :key_ur && error.type == :taken
          t('measurement_types.errors.key_ur_taken')
        else
          error.full_message
        end
      end
      render json: { success: false, errors: errors }
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
    key = @measurement_type.key

    @measurement_type.destroy

    if line_items_count > 0 || customers_count > 0
      flash[:notice] = t('measurement_types.notices.deleted_with_usage',
        key: key,
        line_items_count: line_items_count,
        customers_count: customers_count)
    else
      flash[:notice] = t('measurement_types.notices.deleted', key: key)
    end

    redirect_to measurement_types_path
  end

  private
    def set_measurement_type
      @measurement_type = current_shop.measurement_types.find(params[:id])
    end

    def measurement_type_params
      params.require(:measurement_type).permit(:key_en, :key_ur)
    end
end

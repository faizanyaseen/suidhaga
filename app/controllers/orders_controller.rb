class OrdersController < ApplicationController
  include SubscriptionChecker
  before_action :ensure_owner, only: [:new, :create]

  def index
    @orders = if current_user.owner?
      current_shop.orders.includes(:customer, :tailor).order(created_at: :desc)
    else
      current_user.assigned_orders.includes(:customer).order(created_at: :desc)
    end

    # Search filter
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

    # Status filter
    if params[:status].present?
      @orders = @orders.where(status: params[:status])
    end

    # Customer filter
    if params[:customer_id].present?
      @orders = @orders.where(customer_id: params[:customer_id])
    end

    # Tailor filter
    if params[:tailor_id].present? && current_user.owner?
      @orders = @orders.where(tailor_id: params[:tailor_id])
    end

    if params[:date_range].present?
      case params[:date_range]
      when 'last_week'
        @orders = @orders.where(created_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
      when 'last_month'
        @orders = @orders.where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)
      when 'last_year'
        @orders = @orders.where(created_at: 1.year.ago.beginning_of_year..1.year.ago.end_of_year)
      when 'custom'
        if params[:start_date].present? && params[:end_date].present?
          start_date = Date.parse(params[:start_date]).beginning_of_day
          end_date = Date.parse(params[:end_date]).end_of_day
          @orders = @orders.where(created_at: start_date..end_date)
        end
      end
    end

    @orders = @orders.page(params[:page]).per(10)
  end

  def show
    @order = find_order
  end

  def new
    @order = current_shop.orders.new
    @order.customer_id = params[:customer_id] if params[:customer_id].present?
    @order.line_items.build
    @customers = current_shop.customers
    @tailors = current_shop.tailors
    @measurement_types = current_shop.measurement_types
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      redirect_to @order, notice: 'Order was successfully created.'
    else
      @customers = current_shop.customers
      @tailors = current_shop.tailors
      @measurement_types = current_shop.measurement_types
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @order = find_order
    
    # Only owners can edit orders fully
    unless current_user.owner?
      redirect_to order_path(@order), alert: t('errors.not_authorized') unless @order.tailor_id == current_user.id
    end
    
    if @order.line_items.empty?
      @order.line_items.build
    end
    @customers = current_shop.customers
    @tailors = current_shop.tailors
    @measurement_types = current_shop.measurement_types
  end

  def update
    @order = find_order
    
    if current_user.owner?
      # Owner can update everything
      if @order.update(order_params)
        redirect_to @order, notice: 'Order was successfully updated.'
      else
        @customers = current_shop.customers
        @tailors = current_shop.tailors
        @measurement_types = current_shop.measurement_types
        render :edit, status: :unprocessable_entity
      end
    else
      # Tailors can only update status
      if @order.tailor_id != current_user.id
        redirect_to orders_path, alert: t('errors.not_authorized')
        return
      end
      
      # Only allow status updates for tailors
      allowed_statuses = ['in_progress', 'completed', 'pending']
      if !allowed_statuses.include?(params[:order][:status]) && params[:order][:status].present?
        redirect_to @order, alert: t('errors.invalid_status')
        return
      end
      
      # Process line items status updates
      if params[:order][:line_items_attributes].present?
        params[:order][:line_items_attributes].each do |_, line_item_params|
          if line_item_params[:status].present? && !['in_progress', 'completed'].include?(line_item_params[:status])
            redirect_to @order, alert: t('errors.invalid_line_item_status')
            return
          end
        end
      end
      
      # Create a filtered params hash for tailors
      tailor_params = params.require(:order).permit(
        :status,
        line_items_attributes: [:id, :status]
      )
      
      if @order.update(tailor_params)
        redirect_to @order, notice: 'Order status was successfully updated.'
      else
        @customers = current_shop.customers
        @tailors = current_shop.tailors
        @measurement_types = current_shop.measurement_types
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def mark_complete
    @order = find_order

    begin
      email_sent = false

      ActiveRecord::Base.transaction do
        @order.update!(status: :completed)
        @order.line_items.update_all(status: LineItem.statuses[:completed])

        # Send email notification to customer if email is present
        if @order.customer.email.present?
          OrderMailer.order_completed(@order).deliver_now
          email_sent = true
        end
      end

      message_key = email_sent ? 'order_completed' : 'order_completed_no_email'

      respond_to do |format|
        format.json { render json: { status: 'success', message: t("notices.#{message_key}") } }
        format.html { redirect_to @order, notice: t("notices.#{message_key}") }
      end
    rescue => e
      respond_to do |format|
        format.json { render json: { status: 'error', message: 'Failed to mark order as complete.' } }
        format.html { redirect_to @order, alert: 'Failed to mark order as complete.' }
      end
    end
  end

  def mark_delivered
    @order = find_order
    
    # Only owners can mark as delivered
    unless current_user.owner?
      respond_to do |format|
        format.json { render json: { status: :unauthorized, message: t('errors.not_authorized') } }
        format.html { redirect_to @order, alert: t('errors.not_authorized') }
      end
      return
    end
    
    if @order.update(status: :delivered, delivered_at: Time.current)
      render json: { status: :ok, message: t('orders.notices.marked_delivered') }
    else
      render json: { status: :unprocessable_entity, message: @order.errors.full_messages.join(', ') }
    end
  end

  def print
    @order = find_order
    
    # Only owners can print receipts
    unless current_user.owner?
      redirect_to orders_path, alert: t('errors.not_authorized')
      return
    end
    
    render layout: 'print'
  end

  private
  
  def ensure_owner
    unless current_user.owner?
      redirect_to orders_path, alert: t('errors.not_authorized')
    end
  end

  def find_order
    if current_user.owner?
      current_shop.orders.includes(:customer, :tailor, line_items: { images_attachments: :blob }).find(params[:id])
    else
      # For tailors, we still need to include the customer but we'll limit what's displayed in the view
      current_user.assigned_orders.includes(:customer, line_items: { images_attachments: :blob }).find(params[:id])
    end
  end

  def order_params
    params.require(:order).permit(
      :customer_id,
      :tailor_id,
      :total_price,
      :status,
      :delivery_date,
      line_items_attributes: [
        :id,
        :name,
        :description,
        :price,
        :number_of_pieces,
        :status,
        :_destroy,
        { images: [] },
        { keep_images: [] },
        line_items_measurement_types_attributes: [
          :id,
          :measurement_type_id,
          :value,
          :_destroy
        ]
      ]
    ).tap do |whitelisted|
      if whitelisted[:line_items_attributes].present?
        whitelisted[:line_items_attributes].each do |_, line_item_params|
          line_item_params[:images].reject!(&:blank?) if line_item_params[:images].present?

          if line_item_params[:keep_images].present?
            keep_images = line_item_params.delete(:keep_images)
            if line_item_params[:id].present?
              line_item = LineItem.find(line_item_params[:id])
              
              if line_item_params[:images].present? && !line_item_params[:images].empty?
                combined_images = keep_images.dup
                line_item_params[:images].each { |image| combined_images << image }
                line_item_params[:images] = combined_images
              else
                line_item_params[:images] = keep_images
              end
            end
          end
          
          if line_item_params[:line_items_measurement_types_attributes].is_a?(Hash)
            line_item_params[:line_items_measurement_types_attributes] = 
              line_item_params[:line_items_measurement_types_attributes].values
          end
        end
      end
    end
  end
end 
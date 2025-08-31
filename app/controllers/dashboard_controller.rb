class DashboardController < ApplicationController
  def index
    @stats = calculate_stats
    @revenue_data = calculate_revenue_data
  end

  private

  def calculate_stats
    orders = if current_user.owner?
      current_shop.orders.includes(:customer)
    else
      current_user.assigned_orders.includes(:customer)
    end

    {
      total_orders: orders.count,
      pending_orders: orders.where(status: 'pending').count,
      tomorrow_deliveries: orders.where(
        delivery_date: Date.tomorrow,
        status: ['pending', 'in_progress', 'ready']
      ).count,
      late_orders: orders.where(
        'delivery_date < ? AND delivered_at IS NULL',
        Date.current
      ).where.not(status: 'cancelled').count,
      total_customers: current_user.owner? ? current_shop.customers.count : nil,
      total_tailors: current_user.owner? ? current_shop.tailors.count : nil,
      this_month_revenue: current_user.owner? ? orders.where(
        created_at: Date.current.beginning_of_month..Date.current.end_of_month,
        status: ['completed', 'delivered']
      ).sum(:total_price) : nil,
      recent_orders: orders.order(created_at: :desc).limit(5),
      late_orders_list: orders.where(
        'delivery_date < ? AND delivered_at IS NULL',
        Date.current
      ).where.not(status: 'cancelled').order(:delivery_date).limit(10)
    }
  end

  def calculate_revenue_data
    return { labels: [], data: [] } unless current_user.owner?
    
    # Get last 12 months of revenue data
    months = []
    revenues = []

    (11.downto(0)).each do |i|
      month_start = i.months.ago.beginning_of_month
      month_end = i.months.ago.end_of_month

      revenue = current_shop.orders
                           .where(created_at: month_start..month_end)
                           .where(status: ['completed', 'delivered'])
                           .sum(:total_price)

      months << month_start.strftime("%b %Y")
      revenues << revenue.to_f
    end

    {
      labels: months,
      data: revenues
    }
  end
end

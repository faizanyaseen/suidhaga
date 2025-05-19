module OrdersHelper
  def order_status_color(status)
    case status
    when 'pending'
      'badge-warning'
    when 'in_progress'
      'badge-info'
    when 'completed'
      'badge-success'
    when 'cancelled'
      'badge-error'
    else
      'badge-ghost'
    end
  end
end 
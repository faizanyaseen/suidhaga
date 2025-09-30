module OrdersHelper
  def order_status_color(status)
    case status
    when 'received'
      'badge-info'
    when 'in_progress'
      'badge-warning'
    when 'completed'
      'badge-success'
    when 'delivered'
      'badge-success'
    when 'cancelled'
      'badge-error'
    else
      'badge-ghost'
    end
  end

  def status_badge_class(status)
    case status.to_s
    when 'received'
      'badge badge-info'
    when 'in_progress'
      'badge badge-warning'
    when 'completed'
      'badge badge-success'
    when 'delivered'
      'badge badge-success'
    when 'cancelled'
      'badge badge-error'
    else
      'badge badge-neutral'
    end
  end
end 
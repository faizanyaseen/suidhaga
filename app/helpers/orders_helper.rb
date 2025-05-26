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

  def status_badge_class(status)
    case status.to_s
    when 'pending'
      'badge badge-warning'
    when 'in_progress'
      'badge badge-info'
    when 'completed'
      'badge badge-success'
    when 'cancelled'
      'badge badge-error'
    else
      'badge badge-neutral'
    end
  end
end 
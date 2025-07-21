module ApplicationHelper
  include Pagy::Frontend

  def number_to_currency_br(number)
    number_to_currency(number, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end

  def flash_type_to_class(type)
    case type.to_s
    when 'notice'
      'success'
    when 'alert', 'error'
      'error'
    when 'warning'
      'warning'
    when 'info'
      'info'
    else
      'info'
    end
  end

  def flash_icon(type)
    case type.to_s
    when 'notice'
      content_tag(:svg, xmlns: "http://www.w3.org/2000/svg", class: "stroke-current flex-shrink-0 h-6 w-6", fill: "none", viewBox: "0 0 24 24") do
        content_tag(:path, "", 'stroke-linecap': "round", 'stroke-linejoin': "round", 'stroke-width': "2", d: "M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z")
      end
    when 'alert', 'error'
      content_tag(:svg, xmlns: "http://www.w3.org/2000/svg", class: "stroke-current flex-shrink-0 h-6 w-6", fill: "none", viewBox: "0 0 24 24") do
        content_tag(:path, "", 'stroke-linecap': "round", 'stroke-linejoin': "round", 'stroke-width': "2", d: "M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z")
      end
    when 'warning'
      content_tag(:svg, xmlns: "http://www.w3.org/2000/svg", class: "stroke-current flex-shrink-0 h-6 w-6", fill: "none", viewBox: "0 0 24 24") do
        content_tag(:path, "", 'stroke-linecap': "round", 'stroke-linejoin': "round", 'stroke-width': "2", d: "M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z")
      end
    when 'info'
      content_tag(:svg, xmlns: "http://www.w3.org/2000/svg", class: "stroke-current flex-shrink-0 h-6 w-6", fill: "none", viewBox: "0 0 24 24") do
        content_tag(:path, "", 'stroke-linecap': "round", 'stroke-linejoin': "round", 'stroke-width': "2", d: "M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z")
      end
    else
      content_tag(:svg, xmlns: "http://www.w3.org/2000/svg", class: "stroke-current flex-shrink-0 h-6 w-6", fill: "none", viewBox: "0 0 24 24") do
        content_tag(:path, "", 'stroke-linecap': "round", 'stroke-linejoin': "round", 'stroke-width': "2", d: "M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z")
      end
    end
  end
end

module LayoutHelper
  def page_header(title, &block)
    content_tag :div, class: "flex flex-col sm:flex-row sm:items-center sm:justify-between mb-6 pb-4 border-b" do
      content_tag(:h1, title, class: "text-2xl font-semibold text-gray-900") +
      (block_given? ? content_tag(:div, class: "mt-4 sm:mt-0") { capture(&block) } : "")
    end
  end
end 
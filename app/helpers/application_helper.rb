module ApplicationHelper
  def bootstrap_class_for flash_type
    case flash_type.to_sym
    when :success
      "alert-success" # Green
    when :error
      "alert-danger" # Red
    when :alert
      "alert-warning" # Yellow
    when :notice
      "alert-info" # Blue
    else
      flash_type.to_s
    end
  end

  def nav_link(link_path, options = nil, &block)

    class_name = current_page?(link_path) ? 'current' : ''

    content_tag(:li, :class => class_name) do
      link_to link_path, options, &block
    end
  end
end

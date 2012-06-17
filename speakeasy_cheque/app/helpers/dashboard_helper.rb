module DashboardHelper
  def time_link(text, id, path)
    dash_link_for(text, path, class_name_for(params[:x_axis], id))
  end

  def primary_link(text, id, path)
    dash_link_for(text, path, class_name_for(params[:num], id))
  end

  def secondary_link(text, id, path)
    dash_link_for(text, path, class_name_for(params[:denom], id))
  end

  def clear_link(text, path)
    dash_link_for(text, path)
  end

  def class_name_for(param, id)
    param == id ? 'current' : ''
  end

  def dash_link_for(text, path, class_name = '')
    content_tag(:li, class: class_name) { link_to(text, path) }
  end
end

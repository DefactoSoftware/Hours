module ApplicationHelper

  def nav_path(link_text, link_path, http_method=nil)
    css_class = "navigation"
    css_class << " current" if current_page?(link_path)
    content_tag :li, class: css_class do
      link_to(link_text, link_path, http_method)
    end
  end
end

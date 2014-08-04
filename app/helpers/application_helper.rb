module ApplicationHelper

  def nav_path(link_text, link_path, http_method=nil)
    css_class = "navigation"
    css_class << " current" if current_page?(link_path)
    content_tag :li, class: css_class do
      link_to(link_text, link_path, http_method)
    end
  end

  def user_image_link(user, opts={}, &block)
    link_to user_entries_path(user) do
      if opts[:border]
        concat gravatar_image_tag user.email, gravatar: { secure: true }, class: "image-circle", title: user.full_name, style: "border: 3px solid #{user.full_name.pastel_color}"
      else
        concat gravatar_image_tag user.email, gravatar: { secure: true }, class: "image-circle", title: user.full_name
      end
      concat yield if block_given?
    end
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end
end

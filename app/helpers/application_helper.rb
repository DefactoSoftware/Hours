module ApplicationHelper
  include Twitter::Autolink

  def autolink_tags(text)
    auto_link(text, { hashtag_url_base: "/tags/", hashtag_class: "hashtag" })
  end

  def nav_path(link_text, link_path, http_method=nil)
    css_class = "navigation"
    css_class << " current" if current_page?(link_path)
    content_tag :li, class: css_class do
      link_to(link_text, link_path, http_method)
    end
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def client_title(client)
    html = ""
    if client.logo_url != ""
      html << image_tag(client.logo_url, { class: "logo" })
    else
      html << content_tag(:span, "", {class: "color", style: "background-color:#{client.name.pastel_color};"})
    end
    html << content_tag(:span, client.name)
    html.html_safe
  end

  def current_locale
    I18n.locale
  end

  def billable_entry_checkbox(entry)
    if entry.billed
      "√"
    else
      tag(:input, type: "checkbox", name: "entries_to_bill[]", value: entry.id, data_project_id: entry.project.id)
    end
  end

  def link_to_time_span(span)
    params_time_span = params.fetch(:time_span) { "monthly" }
    link_params = params_time_span == span ? { class: "active" } : {}
    link_to t("report.#{span}"), url_for(time_span: span), link_params
  end

  def selected_param(param)
    params[:filters][param] if params[:filters]
  end
end

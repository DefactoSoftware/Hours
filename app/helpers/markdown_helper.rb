module MarkdownHelper
  def markdown(text)
    options = {
      filter_html:          true,
      hard_wrap:            true,
      link_attributes:      { rel: 'nofollow', target: "_blank" },
      fenced_code_blocks:   true,
    }

    extensions = {
      autolink:                     true,
      superscript:                  true,
      disable_indented_code_blocks: true,
      strikethrough:                true
    }

    renderer = Redcarpet::Render::Safe.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
end

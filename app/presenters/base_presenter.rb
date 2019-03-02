class BasePresenter
  attr_reader :template

  def initialize(model, template)
    @model = model
    @template = template
  end

  def last_entry_time
    I18n.t(
      'info.last_entry',
      time: template.time_ago_in_words(@model.created_at)
    )
  end
end

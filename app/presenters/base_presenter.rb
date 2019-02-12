class BasePresenter
  attr_reader :template

  def initialize(model, template)
    @model = model
    @template = template
  end

  def last_entry_time
    "Your last entry was #{template.time_ago_in_words(@model.created_at)} ago"
  end
end

class HourPresenter < BasePresenter
  def last_entry_link
    template.edit_hour_path(@model)
  end
end

class MileagePresenter < BasePresenter
  def last_entry_link
    template.edit_mileage_path(@model)
  end
end

class MileagesController < EntriesController
  def create
    @entry = Mileage.new(entry_params)
    @entry.user = current_user

    if @entry.save
      redirect_to root_path + "##{controller_name}", notice:
        t("entry_created.mileages")
    else
      redirect_to root_path + "##{controller_name}", notice:
        @entry.errors.full_messages.join(". ")
    end
  end

  def update
    if resource.update_attributes(entry_params)
      redirect_to user_entries_path(current_user) + "#mileages",
                  notice: t("entry_saved")
    else
      redirect_to edit_mileage_path(resource), notice: t("entry_failed")
    end
  end

  def edit
    super
    resource
  end

  private

  def resource
    @mileages_entry ||= current_user.mileages.find(params[:id])
  end

  def entry_params
    params.require(:mileage).
      permit(:project_id, :value, :date).
      merge(date: parsed_date(:mileage))
  end
end

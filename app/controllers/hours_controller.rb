class HoursController < EntriesController
  def create
    @entry = Hour.new(entry_params)
    @entry.user = current_user

    if @entry.save
      redirect_to root_path, notice: t("entry_created.hours")
    else
      redirect_to root_path, notice: @entry.errors.full_messages.join(". ")
    end
  end

  def update
    if resource.update_attributes(entry_params)
      redirect_to user_entries_path(current_user), notice: t("entry_saved")
    else
      redirect_to edit_hour_path(resource), notice: t("entry_failed")
    end
  end

  def edit
    super
    resource
  end

  private

  def resource
    @hours_entry ||= current_user.hours.find(params[:id])
  end

  def entry_params
    params.require(:hour).
      permit(:project_id, :category_id, :value, :description, :date,
             :entry_type_option, :timer_value).
      merge(date: parsed_date(:hour)).
      to_h.
      tap do |attributes|
        if attributes[:entry_type_option] == 'timer' &&
           attributes.key?(:timer_value)
          unless attributes[:timer_value].empty?
            attributes[:value] = attributes[:timer_value]
          end
        end
      end
  end
end

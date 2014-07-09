class EntriesController < ApplicationController
  DATE_FORMAT = "%d/%m/%Y"

  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user
    if @entry.save
      redirect_to root_path, notice: t(:entry_created)
    else
      redirect_to root_path, notice: @entry.errors.full_messages.join(" ")
    end
  end

  def index
    @user = User.find_by_slug(params[:user_id])
    @entries = @user.entries.by_date.page(params[:page]).per(10)
  end

  def update
    @entry = entry
    @entry.update_attributes(entry_params)
    if entry.save
      redirect_to user_entries_path(current_user), notice: t("entry_saved")
    else
      render "edit", notice: t("entry_failed")
    end
  end

  def edit
    @entry = entry
  end


  def destroy
    @entry = entry
    @entry.destroy
    redirect_to user_entries_path(current_user), notice: t('entry_deleted')
  end

  private

  def entry_params
    params.require(:entry)
      .permit(:project_id, :category_id, :hours, :tag_list, :date)
      .merge(date: parsed_date)
  end

  def parsed_date
    Date.strptime(params[:entry][:date], DATE_FORMAT)
  end

  def entry
    current_user.entries.find(params[:id])
  end
end

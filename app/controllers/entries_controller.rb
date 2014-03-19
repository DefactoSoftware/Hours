class EntriesController < ApplicationController
  DATE_FORMAT = "%d/%m/%Y"

  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user
    @entry.date = Date.strptime(entry_params[:date], DATE_FORMAT)
    if @entry.save
      redirect_to root_path, notice: I18n.t(:entry_created)
    else
      redirect_to root_path, notice: @entry.errors.full_messages.join(" ")
    end
  end

  def index
    @user = User.find(params[:user_id])
    @entries = @user.entries
  end

  def update
    @entry = entry
    @entry.update_attributes(entry_params)
    @entry.date = Date.strptime(entry_params[:date], DATE_FORMAT) 
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
    redirect_to user_entries_path(current_user), notice: "Entry successfully deleted"
  end

  private

  def entry_params
    params.require(:entry).permit(:project_id, :category_id, :hours, :date, :tag_list)
  end

  def entry
    current_user.entries.find(params[:id])  
  end    
end

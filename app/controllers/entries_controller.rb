class EntriesController < ApplicationController
  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user
    @entry.date = Date.strptime(entry_params[:date], "%d/%m/%Y")
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

  def destroy
    @entry = current_user.entries.find(params[:id])
    @entry.destroy
    redirect_to user_entries_path(current_user), notice: "Entry successfully deleted"
  end

  private

  def entry_params
    params.require(:entry).permit(:project_id, :category_id, :hours, :date, :tag_list)
  end
end

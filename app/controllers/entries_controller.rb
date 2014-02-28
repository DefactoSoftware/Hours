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

  private

  def entry_params
    params.require(:entry).permit(:project_id, :category_id, :hours, :date)
  end
end

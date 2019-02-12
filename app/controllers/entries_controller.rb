class EntriesController < ApplicationController
  include CSVDownload
  before_action :set_user, :set_last_entry, only: %i[index]

  DATE_FORMAT = "%d/%m/%Y".freeze

  def index
    @hours_entries = @user.hours.by_date.page(params[:hours_pages]).per(20)
    @mileages_entries = @user.mileages.by_date.page(
      params[:mileages_pages]).per(20)

    respond_to do |format|
      format.html { @mileages_entries + @hours_entries }
      format.csv do
        send_csv(
          name: @user.name,
          hours_entries: @user.hours.by_date,
          mileages_entries: @user.mileages.by_date)
      end
    end
  end

  def destroy
    resource.destroy
    redirect_to user_entries_path(current_user) + "##{controller_name}",
                notice: t("entry_deleted.#{controller_name}")
  end

  def edit
    @entry_type = set_entry_type
  end

  private

  def set_entry_type
    params[:controller]
  end

  def set_user
    @user = User.find_by_slug(params[:user_id])
  end

  def parsed_date(entry_type)
    Date.strptime(params[entry_type][:date], DATE_FORMAT)
  end

  def set_last_entry
    hour = @user.hours.by_last_created_at.first
    mileage = @user.mileages.by_last_created_at.first

    @last_entry = if hour&.created_at.to_i >= mileage&.created_at.to_i
                    hour
                  else
                    mileage
                  end
  end
end

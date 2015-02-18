class EntriesController < ApplicationController
  include CSVDownload

  DATE_FORMAT = "%d/%m/%Y".freeze

  def index
    @user = User.find_by_slug(params[:user_id])
    @hours_entries = @user.hours.by_date.page(params[:page]).per(20)
    @mileages_entries = @user.mileages.by_date.page(params[:page]).per(20)

    respond_to do |format|
      format.html { @mileages_entries + @hours_entries }
      format.csv do
        send_csv(
          name: @user.name,
          hours_entries: @hours_entries,
          mileages_entries: @mileages_entries)
      end
    end
  end

  def destroy
    resource.destroy
    redirect_to user_entries_path(current_user) + "##{controller_name}",
                notice: t("entry_deleted.#{controller_name}")
  end

  private

  def parsed_date(entry_type)
    Date.strptime(params[entry_type][:date], DATE_FORMAT)
  end
end

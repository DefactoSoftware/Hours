class SendCsvToThirdPartyController < ApplicationController
  def index
  end

  def new
    @user = current_user
    @third_party_email = params[:third_party][:email]
    ThirdPartyMailer.csv_mail(@user, @third_party_email).deliver_now
    redirect_to user_entries_path(@user), notice: t("entries.send_csv_to_third_party_success")
  end
end

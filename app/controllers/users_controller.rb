class UsersController < ApplicationController
  def show
    @user = User.find_by_slug(params[:id])
    @time_series = TimeSeries.new(entries: @user.entries,
                                  time_span: time_span)
  end

  private

  def time_span
    case params[:time_span]
    when "weekly" then TimeSeries::WEEKLY
    when "yearly" then TimeSeries::YEARLY
    else TimeSeries::MONTHLY
    end
  end
end

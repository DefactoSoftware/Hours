class UsersController < ApplicationController
  def show
    @user = User.find_by_slug(params[:id])
    @time_series = TimeSeries.new(entries: @user.entries,
                                  time_span: time_span)
  end

  def index
    @users = User.all
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_with_password(user_params)
      redirect_to edit_user_path, notice: t(:user_updated)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :current_password)
  end

  def time_span
    case params[:time_span]
    when "weekly" then TimeSeries::WEEKLY
    when "yearly" then TimeSeries::YEARLY
    else TimeSeries::MONTHLY
    end
  end
end

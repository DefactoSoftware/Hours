include TimeSeriesInitializer

class UsersController < ApplicationController
  before_action :set_users, only: [:index, :toggle_active]

  def show
    @time_series = time_series_for(resource)
  end

  def index
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

  def toggle_active
    resource.toggle!(:active)
    redirect_to users_path
  end

  private

  def set_users
    @users ||= User.all
  end

  def resource
    @user ||= User.find_by_slug(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :current_password)
  end
end

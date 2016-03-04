include TimeSeriesInitializer

class UsersController < ApplicationController
  def show
    @time_series = time_series_for(resource)
  end

  def index
    @users = User.all
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.respond_to?(:unconfirmed_email)
      prev_unconfirmed_email = @user.unconfirmed_email
    end

    if @user.update_with_password(user_params)
      flash_key = if update_needs_confirmation?(@user, prev_unconfirmed_email)
                    :update_needs_confirmation
                  else
                    :updated
                  end
      redirect_to edit_user_path, notice: t(".#{flash_key}")
    else
      render :edit
    end
  end

  private

  def resource
    @user ||= User.find_by_slug(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :current_password,
                                 :language)
  end

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end
end

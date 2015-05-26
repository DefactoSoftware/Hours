class AccountsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  before_action :authorize!, only: [:edit, :destroy]

  def new
    @signup = Signup.new
  end

  def create
    @signup = Signup.new(signup_params)
    if @signup.valid?
      unless Hours.single_tenant_mode?
        Apartment::Tenant.create(@signup.subdomain)
        Apartment::Tenant.switch(@signup.subdomain)
      end
      @signup.save

      if Hours.single_tenant_mode?
        redirect_to new_user_session_url(subdomain: false)
      else
        redirect_to new_user_session_url(subdomain: @signup.subdomain)
      end
    else
      render action: "new"
    end
  end

  def edit
    @current_domain = request.host
  end

  def destroy
    current_account.destroy
    Apartment::Tenant.drop(current_subdomain)
  end

  private

  def signup_params
    params.require(:signup)
          .permit(:subdomain, :first_name, :last_name, :email,
                    :password, :password_confirmation)
  end

  def authorize!
    raise ActiveRecord::RecordNotFound unless current_user_owner?
  end
end

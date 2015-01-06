class AccountsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  before_action :authorize!, only: [:edit, :destroy]

  def new
    @account = Account.new
    @account.build_owner
  end

  def create
    @account = Account.new(account_params)
    if @account.valid?
      Apartment::Tenant.create(@account.subdomain)
      Apartment::Tenant.switch(@account.subdomain)
      @account.save
      redirect_to new_user_session_url(subdomain: @account.subdomain)
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

  def account_params
    params.require(:account)
          .permit(:subdomain,
                  owner_attributes: [
                    :first_name, :last_name, :email,
                    :password, :password_confirmation]
                 )
  end

  def authorize!
    raise ActiveRecord::RecordNotFound unless current_user_owner?
  end
end

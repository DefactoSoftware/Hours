class Users::RegistrationsController < Devise::RegistrationsController

  def destroy
    redirect_to root_url
  end

  protected

  def build_resource(hash=nil)
    user = super(hash)
    user.organization = current_account
  end
end

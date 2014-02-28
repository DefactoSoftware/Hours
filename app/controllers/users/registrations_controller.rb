class Users::RegistrationsController < Devise::RegistrationsController

  protected

  def build_resource(hash=nil)
    user = super
    user.organization = current_account
  end
end

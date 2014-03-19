class Users::RegistrationsController < Devise::RegistrationsController

  protected

  def build_resource(hash=nil)
    user = super(hash)
    user.organization = current_account
  end
end

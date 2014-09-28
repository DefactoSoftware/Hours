class Users::RegistrationsController < Devise::RegistrationsController

  def destroy
    redirect_to root_url
  end

  protected

  def build_resource(hash=nil)
    user = super(hash)
    user.organization = current_account
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name) }
  end
end

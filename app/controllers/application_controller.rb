class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:accept_invitation).concat([:first_name, :last_name])
  end

  def authenticate_inviter!
    current_user || authenticate_user!
  end

  def after_invite_path_for(resource_name)
    users_path
  end

  private

  helper_method def current_subdomain
    @current_subdomain ||= current_account.subdomain
  end

  helper_method def current_user_owner?
    current_account.owner == current_user
  end

  def current_account
    @current_account ||= Account.find_by(subdomain: request.subdomain)
  end

  def set_locale
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end
end

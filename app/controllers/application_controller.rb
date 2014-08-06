class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :load_schema, :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_locale

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    klass.new(object, view_context)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email,
               :password, :password_confirmation)
    end
  end

  private

  def current_account
    @current_account ||= Account.find_by(subdomain: request.subdomain)
  end

  helper_method def current_subdomain
    @current_subdomain ||= current_account.subdomain
  end

  def load_schema
    Apartment::Tenant.switch("public")
    return unless request.subdomain.present?

    if current_account
      Apartment::Tenant.switch(request.subdomain)
    else
      redirect_to root_url(subdomain: false)
    end
  end

  def after_sign_out_path(resource_or_scope)
    new_user_session_path
  end

  def set_locale
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end
end

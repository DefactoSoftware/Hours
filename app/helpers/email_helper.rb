module EmailHelper
  def current_subdomain
    Apartment::Tenant.current == "public" ? "" : Apartment::Tenant.current 
  end
end

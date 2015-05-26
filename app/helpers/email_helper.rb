module EmailHelper
  def current_subdomain
    if Hours.single_tenant_mode?
      Hours.application_subdomain || ""
    else
      Apartment::Tenant.current == "public" ? "" : Apartment::Tenant.current
    end
  end
end

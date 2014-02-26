class SubdomainPresent
  def self.matches?(request)
    request.subdomain.present?
  end
end

class SubdomainBlank
  def self.matches?(request)
    request.subdomain.blank?
  end
end

Hours::Application.routes.draw do
  constraints(SubdomainPresent) do
    root "projects#index", as: :subdomain_root
    devise_for :users
    resource :projects, only: [:index, :new, :create]
    resource :categories, only: [:new, :create]
  end

  constraints(SubdomainBlank) do
    root "landing#index"
    resource :accounts, only: [:new, :create]
  end
end

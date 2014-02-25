class SubdomainPresent
  def self.matches?(request)
    request.subdomain.present?
  end
end
Hours::Application.routes.draw do
  constraints(SubdomainPresent) do
    devise_for :users
  end

  root to: "landing#index"

  resource :accounts, only: [:new, :create]
end

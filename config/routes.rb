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
    devise_for :users, :controllers => { registrations: "users/registrations" }
    resources :projects, only: [:index, :new, :create, :show]
    resources :categories, only: [:index, :create, :edit, :update]
    resources :entries, only: [:create, :destroy, :update, :edit]
    resources :users, only: [:index, :update] do
      resources :entries, only: :index
    end

    get "user/edit" => "users#edit", as: :edit_user

    get "account/edit" => "accounts#edit", as: :edit_account
    delete "account" => "accounts#destroy", as: :destroy_account
  end

  constraints(SubdomainBlank) do
    root to: "pages#show", id: "landing"
    get "/pages/*id" => "pages#show", as: :page, format: false

    resource :accounts, only: [:new, :create]
  end
end

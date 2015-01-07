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
    resources :projects, only: [:index, :edit, :new, :update, :create, :show] 
    resources :archives, only: [:index]
    resources :categories, only: [:index, :create, :edit, :update]
    resources :entries, only: [:create, :destroy, :update, :edit] do
      resources :audits, only: [:index]
    end

    resources :users, only: [:index, :update, :show] do
      resources :entries, only: [:index]
    end

    resources :tags, only: [:show]
    resources :clients, only: [:show, :index, :edit, :update, :create]

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

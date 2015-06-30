devise_for :users, controllers: { registrations: "users/registrations" }
resources :archives, only: [:index]
resources :projects, only: [:index, :edit, :new, :update, :create, :show] do
  resources :audits, only: [:index]
end
resources :categories, only: [:index, :create, :edit, :update]
resources :entries, only: [:index]

resources :hours, :mileages, only: [:create, :destroy, :update, :edit, :patch]do
  resources :audits, only: [:index]
end

resources :reports, only: [:index]

resources :billables, only: [:index]

resources :users, only: [:index, :update, :show, :destroy] do
  resources :entries, only: [:index]
end

resources :tags, only: [:show]
resources :clients, only: [:show, :index, :edit, :update, :create]
resources :charges, only: [:new, :create]
delete "charges" => "charges#destroy", as: :destroy_charge
get "charges" => "charges#show", as: :show_charge

get "user/edit" => "users#edit", as: :edit_user
get "account/edit" => "accounts#edit", as: :edit_account
delete "account" => "accounts#destroy", as: :destroy_account
post "billables" => "billables#bill_entries", as: :bill_entries

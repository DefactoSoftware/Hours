get "/pages/*id" => "pages#show", as: :page, format: false

resource :accounts, only: [:new, :create]
resource :message, only: [:create]

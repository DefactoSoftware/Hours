get "/pages/*id" => "pages#show", as: :page, format: false

resource :accounts, only: %i[new create]

Hours::Application.routes.draw do
  devise_for :users
  root to: "landing#index"
end

Blogomat::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :sessions, only: [:create, :index, :destroy]
    resources :users
    resources :posts

    root to: 'api#index'
  end

  root to: 'home#index'
end

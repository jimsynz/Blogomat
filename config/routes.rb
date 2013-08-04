Blogomat::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resource  :sessions, only: [:create, :show, :destroy]
    resources :users,    only: [:show, :index]
    resources :posts,    only: [:create, :show, :index, :update, :destroy]

    root to: 'api#index'
  end

  root to: 'home#index'
end

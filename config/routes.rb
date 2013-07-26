Baseline::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resource :sessions, only: [:create, :index, :destroy]
    resource :users

    root to: 'api#index'
  end

  root to: 'home#index'
end

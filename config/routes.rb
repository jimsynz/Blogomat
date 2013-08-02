Blogomat::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resource :sessions, only: [:create, :destroy] do
      # FIXME I don't know why this is needed, but putting it in the only array above doesn't work.
      get :index, on: :collection
    end
    resource :users

    root to: 'api#index'
  end

  root to: 'home#index'
end

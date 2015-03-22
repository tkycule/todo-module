Rails.application.routes.draw do

  root "sessions#new"

  resources :users, only: [:new, :create, :edit, :update]

  resources :sessions, only: [:new, :create, :destroy]
  get 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout, :via => [:get, :post]

  resources :tasks, except: [:show] do
    collection do
      get "completed"
      get "deleted"
    end
    member do
      patch "complete"
      patch "revert"
    end
  end

  api_version(:module => "V1", :path => {:value => "v1"}, :defaults => {:format => "json"}) do

    resources :users, only: [:create]
    resources :sessions, only: [:create]

    resources :tasks, only: [:index, :create, :show, :update, :destroy] do
      member do
        match "complete", via: [:patch, :put]
        match "revert", via: [:patch, :put]
      end
    end
  end

end

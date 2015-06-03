Myflix::Application.routes.draw do
  root to: "pages#front"
  get "home", to: "videos#index"
  get "register", to: "users#new"
  get "sign_in", to: "sessions#new"
  get "sign_out", to: "sessions#destroy"
  get "my_queue", to: "queue_items#index"
  post "update_queue", to: "queue_items#update_queue"

  resources :queue_items, only: [:create, :destroy]
  get "ui(/:action)", controller: 'ui'

  resources :videos, only: [:show, :index] do
    collection do
      get :search, to: "videos#search"
    end
    resources :reviews, except: [:edit, :update, :destory]
  end

  get "people", to: 'relationships#index'
  resources :relationships, only: [:destroy, :create]

  get "forgot_password", to: "forgot_passwords#new"
  get "forgot_password_confirmation", to: "forgot_passwords#confirm"
  resources :password_resets, only: [:show, :create]
  resources :forgot_passwords, only: [:create]
  get "expired_token", to: "pages#expired_token"

  resources :invitations, only: [:new, :create]
  get 'register/:token', to: "users#new_with_invitation_token", as: "register_with_token"

  resources :categories, only: [:show]
  resources :users, only: [:create, :show]
  resources :sessions, only: [:create]
end

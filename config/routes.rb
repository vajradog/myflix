Myflix::Application.routes.draw do
  root to: "pages#front"
  get 'home', to: "videos#index"
  get 'register', to: "users#new"
  get 'sign_in', to: "sessions#new"
  get 'sign_out', to: "sessions#destroy"
  get 'my_queue', to: "queue_items#index"
  post 'update_queue', to: "queue_items#update_queue"

  resources :queue_items, only: [:create, :destroy]
  get 'ui(/:action)', controller: 'ui'


  resources :videos, only: [:show, :index] do 
    collection do 
      get :search, to: "videos#search"
    end
    resources :reviews, except: [:edit, :update, :destory]
  end

  resources :categories, only: [:show]
  resources :users, only: [:create]
  resources :sessions, only: [:create]
end

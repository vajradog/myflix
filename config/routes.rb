Myflix::Application.routes.draw do
	get 'home', to: "videos#index"
  get 'ui(/:action)', controller: 'ui'

  resources :videos, only: [:show]
end

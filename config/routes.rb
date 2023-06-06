Rails.application.routes.draw do
  get 'friend_requests/create'
  get 'friend_requests/edit'
  get 'friend_requests/destroy'
  get 'users/index'
  get 'users/show'
  root "home#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  
  resources :users, only: [:index, :show]

  resources :users do 
    resources :profiles, only: [:show, :new]
  end

  resources :profiles, only: [:edit, :create, :update, :destroy]

  resources :friend_requests, only: [:create, :update, :destroy]
end

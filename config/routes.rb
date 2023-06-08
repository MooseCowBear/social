Rails.application.routes.draw do
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

  resources :friend_requests, only: [:index, :create, :destroy]

  resources :friend_requests do
    post :accept, on: :collection
    post :decline, on: :collection
    post :unfriend, on: :collection
  end

  resources :posts
end

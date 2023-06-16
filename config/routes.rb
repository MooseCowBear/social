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

  resources :posts do
    resources :comments
    resources :likes, only: [:create, :destroy]
  end

  resources :comments do
    resources :comments
  end

  resources :comments

  resources :notifications, only: [:index]

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all 
  match "/422", to: "errors#unprocessable_content", via: :all 
end

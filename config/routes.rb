Rails.application.routes.draw do
  root "home#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  
  resources :users, only: [:index, :show]

  resources :profiles, only: [:show, :new, :edit, :create, :update, :destroy]
end

Rails.application.routes.draw do
  devise_for :users
  # get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :projects
  resources :environments

  # Defines the root path route ("/")
  root "home#index"
  match "privacy_policy", to: "home#privacy_policy", via: :all
end

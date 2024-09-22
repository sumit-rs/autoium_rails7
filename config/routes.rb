Rails.application.routes.draw do
  devise_for :users
  # get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :projects do
    resources :roles do
    end
    resources :team_members do
      collection do
        post :assign_existing_member
      end
    end
  end
  resources :environments

  # Defines the root path route ("/")
  root "home#index"
  match "fetch-team-members", to: "team_members#fetch_team_members", via: [:get, :post]
  match "privacy_policy", to: "home#privacy_policy", via: :all
  match "project_roles", to: "roles#project_roles", via: :get, as: "access_roles"
end

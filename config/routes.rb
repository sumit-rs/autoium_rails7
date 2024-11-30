Rails.application.routes.draw do
  devise_for :users
  # get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :environments, only: [:index] do
        resources :test_suites, only: [:index, :create] do
          resources :test_cases, only: [:index, :create, :show, :update]
        end
      end

      resources :users, only: [:index] do
        collection do
          post :login
          get :logout
        end
      end
    end
  end
  #end of api namespace

  resources :projects do
    resources :team_members do
      collection do
        post :assign_existing_member
      end
    end
  end

  resources :environments do
    member do
      get :login_details
      post :login_details

      get :git_branch_details
      post :git_branch_details
    end
    resources :custom_commands
    resources :test_plans
    resources :test_roles

    resources :test_suites do
      member do
        get :assign_users
        post :assign_users
      end

      resources :test_cases do
        collection do
          get :selenium_custom_code
        end
      end

      resources :manual_test_cases do
        member do
          delete :delete_attachment
        end
      end
    end
  end

  resources :assign_suites, only: [:index] do
    collection do
      get :manual
    end
    member do
      get :manual_cases
    end
  end

  resources :manual_case_results do
  end

  resources :suite_reports, only:[:index, :show]

  # Defines the root path route ("/")
  root "home#index"
  match "fetch-team-members", to: "team_members#fetch_team_members", via: [:get, :post]
  match "privacy_policy", to: "home#privacy_policy", via: :all
  match "project_roles", to: "roles#project_roles", via: :get, as: "access_roles"
end

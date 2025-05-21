Rails.application.routes.draw do

  # get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do

    scope '/java', defaults: { format: :json } do
      post 'login_user', to: 'selenium#login_user'
      get 'get_scheduler', to: 'selenium#get_scheduler'
      get 'software_version', to: 'selenium#software_version'

      get 'get_projects', to: 'selenium#get_projects'
      get 'get_environments', to: 'selenium#get_environments'
      get 'get_environment', to: 'selenium#get_environment'
      get 'get_custom_command', to: 'selenium#get_custom_commands'

      get 'get_test_suites', to: 'selenium#get_test_suites'
      get 'get_test_suite', to: 'selenium#get_test_suite'
      post 'schedule_test_suite', to: 'selenium#schedule_test_suite'
      get 'unschedule_test_suite', to: 'selenium#unschedule_test_suite'

      get 'get_all_test_cases', to: 'selenium#get_test_cases'

      post 'create_result_suite', to: 'selenium#create_result_suite'
      post 'create_result_case', to: 'selenium#create_result_case'
      post 'update_result_suite', to: 'selenium#update_result_suite'
      post 'update_scheduler_status', to: 'selenium#update_scheduler_status'
      post 'upload_video', to: 'selenium#upload_video'
      post 'upload_screenshot', to: 'selenium#upload_screenshot'
    end

    namespace :v1 do
      resources :projects, only: [:index]

      resources :environments, only: [:index] do
        resources :test_suites, only: [:index, :create] do
          resources :test_cases, only: [:index, :create, :show, :update]
          resources :manual_test_cases, only: [:index, :create, :show, :update]
        end
        resources :custom_commands, only: [:index]
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
    collection do
      get :get_environments
    end
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
    resources :test_plans do
      collection do
        get :flow_states
        get :hierarchy
        post :hierarchy
        get :load_plan_tree
      end
    end
    resources :test_roles

    resources :test_suites do
      member do
        get :assign_users
        post :assign_users
        get :remove_assign_suite
      end

      collection do
        get :import
        post :import
        get :automated
      end

      resources :test_cases do
        collection do
          get :selenium_custom_code
          get :export
        end
      end

      resources :manual_test_cases do
        member do
          delete :delete_attachment
        end
      end

      resources :schedulers do
        resources :results, only: [:index, :update] do
          member do
            get :status_override
          end
          collection do
            get :mark_as_demo_video
            get :download_results
            post :upload_recording
            get :delete_recording
          end
        end
      end

      resources :periodics
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

  resources :suite_reports, only:[:index, :show] do
    collection do
      get :automated
    end
  end
  resources :software_versions

  resource :session, only: [:create, :destroy] do
    collection do
      get :login
    end
  end

  resources :users, only: [:edit, :update] do
    member do
      get :settings
      post :settings
      delete :remove_invitation
      get :resend_invitation
    end
    collection do
      get :invite
      post :invite
      get :accept_invitation
      get :forgot_password
      post :forgot_password
      get :reset_password
    end
  end

  match "suites", to: "test_suites#suites", via: [:get]
  match "load_image", to: "file_handler#load_image", via: [:get]
  match "load_video", to: "file_handler#load_video", via: [:get]
  match "fetch-team-members", to: "team_members#fetch_team_members", via: [:get, :post]
  match "privacy_policy", to: "home#privacy_policy", via: :get
  match "documentation", to: "home#documentation", via: :get
  match "project_roles", to: "roles#project_roles", via: :get, as: "access_roles"

  # Defines the root path route ("/")
  #
  root "home#index"
end

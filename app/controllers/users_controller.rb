class UsersController < ApplicationController

  before_action :user_projects_and_environments
  def settings
    if request.post?
      user = Current.user
      user.prefer_environment = params[:user][:prefer_environment]
      user.prefer_project = params[:user][:prefer_project]
      user.save
      Current.user = user
      flash[:success] = "User default preference of project and environment has been saved."
      if Current.user.prefer_environment.present?
        if params[:redirect] == 'suites' and
          redirect_to environment_test_suites_path(Current.user.prefer_environment) and return
        end
      end
      redirect_to users_settings_path(redirect:params[:redirect])
    end
  end
end
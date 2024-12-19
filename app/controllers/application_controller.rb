class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :populate_current_user

  def populate_current_user
    Current.user = current_user.present? ? current_user : nil
  end

  protected

  def user_projects_and_environments
    @projects = Current.user.assign_projects.uniq.pluck(:name,:id)
    @environments = Environment.where(project_id: Current.user.prefer_environment).pluck(:name,:id)
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end

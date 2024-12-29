class ApplicationController < ActionController::Base
  # -------------------------------------------------------------
  before_action :restricted_to_sign_in_user
  before_action :populate_current_user
  # -------------------------------------------------------------

  helper_method :logged_in?
  # -------------------------------------------------------------

  def populate_current_user
    Current.user = if _user = User.where(id: session[:user_id]).take
                     _user
                   else
                     nil
                   end
  end

  def logged_in?
    populate_current_user.present?
  end
  def restricted_to_sign_in_user
    redirect_to(login_session_path, notice: 'Restricted access. Please login.') unless logged_in?
  end

  protected

  def user_projects
    @projects = Current.user.assign_projects.uniq
  end
  def user_projects_and_environments
    @projects = Current.user.assign_projects.uniq.pluck(:name,:id)
    @environments = Environment.where(project_id: Current.user.prefer_environment).pluck(:name,:id)
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end

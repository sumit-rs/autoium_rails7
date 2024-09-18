class EnvironmentsController < ApplicationController
  before_action :get_environment, only: %i[show edit update destroy]
  before_action :get_projects
  def index
    @environments = Environment.where(project_id: Current.user.projects.collect(&:id))
  end

  def show; end

  def edit; end

  def update
    if @environment.update(environment_params)
      flash[:success] = 'Environment Update Successfully.'
      redirect_to environments_path
    else
      flash.now[:errors] = @environment.errors.full_messages
      render :edit
    end
  end
  def new
    @environment = Environment.new
  end

  def create
    @environment = Environment.new(environment_params)
    @environment.user = Current.user
    if @environment.save
      flash[:success] = "Environment Created Successfully. Kindly fill additional details under 'Login, Custom Command & Git' section."
      redirect_to edit_environment_path(@environment)
    else
      flash.now[:errors] = @environment.errors.full_messages
      render :new
    end
  end

  def destroy
    if @environment.delete
      flash[:success] = 'Environment Deleted Successfully'
    else
      flash[:errors] = @environment.errors.full_messages
    end
    redirect_to environments_path
  end

  private

  def get_environment
    @environment = Environment.find(params[:id])
  end

  def get_projects
    @projects = Project.pluck(:name, :id)
  end
  def environment_params
    params.require(:environment).permit(:name, :url, :project_id, :login_required, :user_name, :password, :login_field, :password_field, :action_button, :action_type, :user_email, :selenium_tester_url, :sleep_status)
  end
end

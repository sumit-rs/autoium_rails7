class EnvironmentsController < ApplicationController
  before_action :get_environment, only: %i[show edit update destroy login_details git_branch_details]
  before_action :get_projects
  def index
    @environments = Environment.where(project_id: Current.user.assign_projects.collect(&:id))
  end

  def show; end

  def edit; end

  def login_details
    if request.post?
      @environment.login_required = true
      if @environment.update(environment_params)
        flash[:success] = 'Login details updated successfully.'
        redirect_to login_details_environment_path(@environment)
      else
        flash.now[:errors] = @environment.errors.full_messages
      end
    end
  end

  def git_branch_details
    if request.post?
      @environment.observe_git_branch = true
      if @environment.update(environment_params)
        flash[:success] = 'Git details updated successfully.'
        redirect_to git_branch_details_environment_path(@environment)
      else
        flash.now[:errors] = @environment.errors.full_messages
      end
    end
  end

  def update
    if @environment.update(environment_params)
       flash[:success] = 'Environment updated successfully.'
       redirect_to edit_environment_path(@environment)
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
      flash[:success] = "Environment created successfully. Kindly fill additional details under 'Login, Custom Command & Git' section."
      redirect_to edit_environment_path(@environment)
    else
      flash.now[:errors] = @environment.errors.full_messages
      render :new
    end
  end

  def destroy
    redirect_to environments_path, notice: "You are not allowed to delete the environment which are created by other user." and return if Current.user == @environment.user or @environment.project.creator == Current.user

    if @environment.delete
      flash[:success] = 'Environment deleted Successfully.'
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
    @projects = user_projects.pluck(:name, :id)
  end
  def environment_params
    params.require(:environment).permit(:name, :url, :project_id,
                                        :login_required, :user_name, :password, :login_field, :password_field, :action_button, :action_type, :user_email, :selenium_tester_url, :sleep_status,
                                        :git_provider, :git_branch, :git_organization, :git_repo_name, :git_access_token
    )
  end
end

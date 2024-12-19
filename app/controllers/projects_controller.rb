class ProjectsController < ApplicationController

  before_action :get_project, only: %i[show edit update destroy]
  def index
    @projects = Current.user.assign_projects.uniq
  end

  def show; end

  def edit; end

  def update
    if @project.update(project_params)
      flash[:success] = 'Project updated successfully.'
      redirect_to projects_path
    else
      flash.now[:errors] = @project.errors.full_messages
      render :edit
    end
  end
  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.creator = Current.user
    if @project.save
      flash[:success] = 'Project created successfully.'
      redirect_to projects_path
    else
      flash.now[:errors] = @project.errors.full_messages
      render :new
    end
  end

  def destroy
    if @project.destroy
      flash[:success] = 'Project deleted Successfully.'
    else
      flash[:errors] = @project.errors.full_messages
    end
    redirect_to projects_path
  end

  def get_environments
    @environments = Environment.where(project_id: params.dig(:user,:prefer_project))
  end

  private

  def get_project
    @project = Project.find(params[:id])
  end
  def project_params
    params.require(:project).permit(:name, :description, :save_to_s3, :s3_bucket_name, :s3_access_key, :s3_secret_key, :s3_region_name)
  end
end

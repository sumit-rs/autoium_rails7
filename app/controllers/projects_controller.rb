class ProjectsController < ApplicationController

  before_action :get_project, only: %i[show edit update destroy]
  def index
    @projects = Current.user.projects
  end

  def show; end

  def edit; end

  def update
    if @project.update(project_params)
      flash[:success] = 'Project Update Successfully.'
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
    @project.user = Current.user
    if @project.save
      flash[:success] = 'Project Created Successfully.'
      redirect_to projects_path
    else
      flash.now[:errors] = @project.errors.full_messages
      render :new
    end
  end

  def destroy
    if @project.delete
      flash[:success] = 'Project Deleted Successfully'
    else
      flash[:errors] = @project.errors.full_messages
    end
    redirect_to projects_path
  end

  private

  def get_project
    @project = Project.find(params[:id])
  end
  def project_params
    params.require(:project).permit(:name, :description, :save_to_s3, :s3_bucket_name, :s3_access_key, :s3_secret_key, :s3_region_name)
  end
end

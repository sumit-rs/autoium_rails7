class RolesController < ApplicationController
  before_action :get_project, except: [:project_access_role, :project_roles]
  before_action :get_project_access_role, only: %i[show edit update destroy]
  def index
    _project_ids = params[:project_id] || Current.user.projects.collect(&:id)
    @roles = ProjectAccessRole.where(project_id: _project_ids)
  end

  def show; end

  def edit; end

  def update
    if @project_access_role.update(project_access_role_params)
      flash[:success] = 'Project access role update successfully.'
      redirect_to project_roles_path(@project)
    else
      flash.now[:errors] = @project_access_role.errors.full_messages
      render :edit
    end
  end
  def new
    @project_access_role = ProjectAccessRole.new
  end

  def create
    @project_access_role = ProjectAccessRole.new(project_access_role_params)
    @project_access_role.creator = Current.user
    if @project_access_role.save
      flash[:success] = 'Project access role created Successfully.'
      redirect_to project_roles_path(@project)
    else
      flash.now[:errors] = @project_access_role.errors.full_messages
      render :new
    end
  end

  def destroy
    if @project_access_role.destroy
      flash[:success] = 'Project access role Deleted Successfully.'
    else
      flash[:errors] = @project_access_role.errors.full_messages
    end
    redirect_to project_roles_path(@project)
  end

  private

  def get_project
    @project = Project.find(params[:project_id])
  end

  def get_project_access_role
    @project_access_role = ProjectAccessRole.find(params[:id])
  end
  def project_access_role_params
    params.require(:project_access_role).permit(:name, :description, :project_id)
  end
end

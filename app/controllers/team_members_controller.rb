class TeamMembersController < ApplicationController
  before_action :get_project, except: [:fetch_team_members]
  before_action :get_user, only: %i[show edit update destroy]
  def index
    @project_users = User.joins(:project_team_members).where('project_team_members.project_id': params[:project_id]).uniq
  end

  def new
    @user = User.new
  end
  def create
    @user = User.new(team_member_params)
    @user.allow_generate_password = true
    if @user.save
      flash[:success] = 'User has been assigned to project and send out to access link to user.'
      redirect_to project_team_members_url(@project)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(team_member_params)
      flash[:success] = 'Tem member has been updated.'
      redirect_to project_team_members_url(@project)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end
  def destroy
    if @user.destroy
      flash[:success] = 'User deleted Successfully.'
    else
      flash[:errors] = @user.errors.full_messages
    end
    redirect_to project_team_members_url
  end

  def assign_existing_member
    @user = User.new
    user = User.where(email: team_member_params[:email]).take
    access_role = ProjectAccessRole.where(id: team_member_params[:project_access_role_id]).take
    project_team_member = ProjectTeamMember.find_or_initialize_by(team_member: user, project: @project, project_access_role: access_role)
    if project_team_member.save
      flash[:success] = 'User has been assigned to project and send out to access link to user'
      redirect_to project_team_members_url(@project)
    else
      flash.now[:errors] = project_team_member.errors.full_messages
      render :new
    end
  end

  def fetch_team_members
    users = User.where("first_name like ? OR last_name like ? OR email like ?", "#{params[:term]}%", "#{params[:term]}%", "#{params[:term]}%")
    render json: {results: users.collect{|user| {id: user.email, text: "#{user.full_name} <#{user.email}> "}}}
  end

  private

  def get_project
    @project = Project.find(params[:project_id])
  end

  def get_user
    @user = User.find(params[:id])
  end

  def team_member_params
    params.require(:user).permit(:first_name, :last_name, :email, :project_id, :project_access_role_id)
  end
end

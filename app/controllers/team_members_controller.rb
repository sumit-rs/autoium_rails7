class TeamMembersController < ApplicationController
  before_action :get_project, except: [:fetch_team_members]
  before_action :get_user, only: %i[show edit update]

  def index
    @project_users = User.joins(:project_team_members).select('users.*,project_team_members.id as ptm').where('project_team_members.project_id': params[:project_id]).uniq
  end

  def new
    @user = User.new
  end

  #this method is not being used any more - it was written to invite external user
  # Logic has shifted while assign manual suite to user
  def create
    @user = User.new(team_member_params)
    @user.project_id = @project.id
    @user.allow_generate_password = true
    if @user.save
      flash[:success] = 'User has been assigned to project.'
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
    project_team_member = ProjectTeamMember.where(id: params[:id]).take
    if project_team_member.destroy
      flash[:success] = 'Team member has been deleted from project successfully.'
    else
      flash[:errors] = project_team_member.errors.full_messages
    end
    redirect_to project_team_members_url
  end

  def assign_existing_member
    @user = User.new
    user = User.where(email: team_member_params[:email]).take
    project_team_member = ProjectTeamMember.find_or_initialize_by(team_member: user, project: @project)
    if user and project_team_member.valid?
      project_team_member.save
      flash[:success] = 'User has been assigned to project.'
      redirect_to project_team_members_url(@project)
    else
      flash.now[:errors] = "Email can't be blank."
      render :new
    end
  end

  def fetch_team_members
    users = User.where("first_name like ? OR last_name like ? OR email like ?", "#{params[:term]}%", "#{params[:term]}%", "#{params[:term]}%")
    if params[:format_id]
      render json: {results: users.collect{|user| {id: user.id, text: "#{user.full_name} <#{user.email}> "}}}
    else
      render json: {results: users.collect{|user| {id: user.email, text: "#{user.full_name} <#{user.email}> "}}}
    end
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

class UsersController < ApplicationController
  skip_before_action :restricted_to_sign_in_user, only: [:accept_invitation, :forgot_password, :reset_password]

  before_action :user_projects_and_environments, only: [:settings]
  before_action :redirect_if_not_admin, only: [:invite, :remove_invitation, :resend_invitation]

  def edit
  end

  def update
    _user = Current.user
    if _user.update(user_params)
      flash[:success] = 'Your information has been updated successfully.'
      redirect_to edit_user_path(Current.user)
    else
      flash.now[:errors] = _user.errors.full_messages
      render :edit
    end
  end

  def settings
    if request.post?
      user = Current.user
      user.prefer_environment = params[:user][:prefer_environment]
      user.prefer_project = params[:user][:prefer_project]
      user.save
      flash[:success] = "User default preference of project and environment has been saved."
      if Current.user.prefer_environment.present?
        redirect_to environment_test_suites_path(Current.user.prefer_environment) and return if params[:redirect] == 'suites'
        redirect_to suite_reports_path and return if params[:redirect] == 'reports'
      end
      redirect_to settings_user_path(Current.user,redirect:params[:redirect])
    end
  end

  def invite
    @user = User.new
    @user_invitations = User.where.not(invitation_sent: nil)

    if request.post?
      @user = User.new(user_invite_params)
      @user.allow_generate_password = true
      @user.invitation_sent = DateTime.now
      @user.invitation_token = User.random_token(20)

      if @user.save
        flash[:success] = 'Invitation link has been sent to user.'
        redirect_to invite_users_path
      else
        flash.now[:errors] = @user.errors.full_messages
      end
    end
  end

  def remove_invitation
    user = User.where(id: params[:id]).where.not(invitation_token: nil).take
    if user.present?
      if user.destroy
        flash[:success] = 'Invitation has been deleted Successfully.'
      else
        flash[:errors] = user.errors.full_messages
      end
    end
    redirect_to invite_users_path
  end

  def resend_invitation
    user = User.where(id: params[:id]).where.not(invitation_token: nil).take
    if user.present?
      user.invitation_token = User.random_token(20)
      user.save
      flash[:success] = 'Invitation has been resend Successfully.'
    end
    redirect_to invite_users_path
  end

  def accept_invitation
    _user = User.where(invitation_token: params[:token]).take
    if _user.present?
      _user.invitation_token = nil
      _user.allow_generate_password = true
      if _user.save
        Thread.new{ NotifyMailer.credentials_email(_user).deliver_now }
        flash[:success] = 'You account has been verified. We have sent your credentials on your email address.'
      else
        flash[:errors] = _user.errors.full_messages
      end
    else
      flash[:errors] = 'Invalid invitation link.'
    end
    redirect_to login_session_path
  end

  def forgot_password
    redirect_to root_path and return if Current.user.present?
    if request.post?
      if params[:email].blank?
        redirect_to forgot_password_users_path, notice: 'Email address is required.' and return
      else
        _user = User.where(email: params[:email]).take
        if _user.present?
          _user.reset_password_token = User.random_token(20)
          _user.reset_password_sent_at = DateTime.now
          _user.save
          Thread.new{ NotifyMailer.forgot_password(_user).deliver_now }
        end
        redirect_to login_session_path, notice: 'Reset password instruction has been sent to your registered email address.' and return
      end
    end
  end

  def reset_password
    _user = User.where(reset_password_token: params[:token]).take
    if _user.present?
      _user.reset_password_token = nil
      _user.allow_generate_password = true
      if _user.save
        Thread.new{ NotifyMailer.credentials_email(_user, 'reset_password').deliver_now }
        flash[:success] = 'You password has been changed. We have sent your credentials on your email address.'
      else
        flash[:errors] = _user.errors.full_messages
      end
    else
      flash[:errors] = 'Reset password link either invalid or expired.'
    end
    redirect_to login_session_path
  end

  private

  def redirect_if_not_admin
    redirect_to root_path, notice: "You are not allowed to perform this action." and return unless Current.user.is_admin?
  end
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def user_invite_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :invitation_sent)
  end
end
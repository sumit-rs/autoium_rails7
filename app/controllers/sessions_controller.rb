class SessionsController < ApplicationController
  skip_before_action :restricted_to_sign_in_user, only: [:login, :create]

  def login
    redirect_to(root_path) and return if Current.user.present?
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully"
    else
      redirect_to(login_session_path, notice: "Invalid credentials! Please try again.") and return
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_session_path, notice: "Logged out successfully"
  end

end

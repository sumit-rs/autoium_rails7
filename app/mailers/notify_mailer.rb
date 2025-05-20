class NotifyMailer < ApplicationMailer
  def development_team(message, subject)
    @data = message
    mail(to: ENV["EXCEPTION_RECIPIENTS"], subject: "[ATTENTION] [#{ENV['APP_NAME']}] #{subject}")
  end

  def invitation_link(user)
    @user = user
    @invitation_url = accept_invitation_users_url(token: @user.invitation_token)
    mail(to: @user.email, subject: "Welcome to our #{ENV['APP_NAME']} platform!")
  end

  def forgot_password(user)
    @user = user
    @reset_password_url = reset_password_users_url(token: @user.reset_password_token)
    mail(to: @user.email, subject: "#{ENV['APP_NAME']} Reset password instructions.")
  end

  def credentials_email(user, for_action = 'accept_invitation')
    @user = user
    @action = for_action
    mail(to: @user.email, subject: "#{ENV['APP_NAME']} platform account credentials.")
  end
end

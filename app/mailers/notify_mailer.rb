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

  def credentials_email(user)
    @user = user
    mail(to: @user.email, subject: "Your #{ENV['APP_NAME']} platform account credentials.")
  end
end

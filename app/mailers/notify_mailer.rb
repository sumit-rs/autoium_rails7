class NotifyMailer < ApplicationMailer
  def development_team(message, subject)
    @data = message
    mail(to: ENV["EXCEPTION_RECIPIENTS"], subject: "[ATTENTION] [#{ENV['SITE_URL']}] #{subject}")
  end

  def invitation_link(user)
    @user = user
    @invitation_url = "#{ENV['SITE_URL']}/users/accept_invitation?token=#{@user.invitation_token}"
    mail(to: @user.email, subject: 'Welcome to our Autonium platform!')
  end

  def credentials_email(user)
    @user = user
    mail(to: @user.email, subject: 'Your Autonium platform account credentials.')
  end
end

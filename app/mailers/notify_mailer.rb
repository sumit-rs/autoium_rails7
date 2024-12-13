class NotifyMailer < ApplicationMailer
  def development_team(message, subject)
    @data = message
    mail(to: ENV["EXCEPTION_RECIPIENTS"], subject: "[ATTENTION] [#{ENV['SITE_URL']}] #{subject}")
  end
end

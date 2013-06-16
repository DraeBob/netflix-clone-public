class AppMailer < ActionMailer::Base
  default from: 'myflix_admin@example.com'

  def notify_on_new_user(user)
    @user = user
    mail to: user.email, subject: "You registered tealeaf myflix !"
  end

  def password_reset_confirmation(user)
    @user = user
    mail to: user.email, subject: "Password reset request - myflix!"
  end

  def invite_friend(invitation)
    @invitation = invitation
    mail to: invitation.friend_email, subject: "Invitation to join myflix!"
  end

  require 'rest_client'

  API_KEY = ENV['MAILGUN_API_KEY']
  API_URL = "https://api:#{API_KEY}@api.mailgun.net/v2/mailgun.net"

  def invite_friend(invitation)
    @invitation = invitation
    RestClient.post API_URL+"/messages", 
        :from => default_sender,
        :to => invitation.friend_email,
        :subject => "Invitation to join myflix!",
  end

  def default_sender
    'myflix_admin@example.com'
  end
end
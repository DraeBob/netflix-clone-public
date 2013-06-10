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

  def invite_friend(inviter, invitation, register_url)
    @inviter = inviter
    @invitation = invitation
    @new_user_path = register_url
    mail to: invitation.friend_email, subject: "Invitation to join myflix!"
  end
end
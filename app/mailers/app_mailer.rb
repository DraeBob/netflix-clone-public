class AppMailer < ActionMailer::Base
  def notify_on_new_user(user)
    @user = user
    mail from: 'info@example.com', to: user.email, subject: "You registered tealeaf myflix !"
  end
end
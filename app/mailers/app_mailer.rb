class AppMailer < ActionMailer::Base
  default from: 'yuichih87@gmail.com'

  def notify_on_new_user(user)
    @user = user
    mail to: user.email, subject: "You registered tealeaf myflix !"
  end
end
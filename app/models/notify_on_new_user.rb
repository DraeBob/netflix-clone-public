class NotifyOnNewUser

  def notify_on_new_user(user)
    RestClient.post(messaging_api_end_point,
      from: "admin@myflix-yuichi.com",
      to: user.email,
      subject: "You registered tealeaf myflix !",
      html: notify_on_new_user_body(user)
    )
  end
 
  private

  def api_key
    @api_key ||= ENV["MAILGUN_API_KEY"]
  end

  def mailgun_api_domain
    @mailgun_api_domain ||= ENV["MAILGUN_API_DOMAIN"]
  end

  def messaging_api_end_point
    @messaging_api_end_point ||= "https://api:#{api_key}@api.mailgun.net/v2/#{mailgun_api_domain}/messages"
  end

  def notify_on_new_user_body(user)
    <<-EMAIL
    <html>
      <body>
        <h1>
          Welcome to tealeaf myflix, #{user.fullname}!
        </h1>
      </body> 
    </html>
    EMAIL
  end
end
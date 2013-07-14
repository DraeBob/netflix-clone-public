class Registration 
  attr_reader :error_message

  def initialize(user)
    @user = user
  end
   
  def user_registration(stripe_token, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Customer.create(
        :plan => "premium",
        :card => stripe_token,
        :email => @user.email
      ) 
      if charge.successful?
        @user.save
        handle_invitation(invitation_token)
        AppMailer.notify_on_new_user(@user).deliver
        @status = :success
        self
      else
        @status = :failed
        @error_message = charge.error_message
        self
      end
    else
      @status = :failed
      @error_message = 'Cannot create an user, check the input and try again'
      self
    end
  end

  def successful?
    @status == :success
  end

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end 
  end

end
class Registration < Draper::Decorator
  attr_reader :user, :token, :invitation_token

  def initialize(user, token, invitation_token)
    @user = user
    @token = token
    @invitation_token = invitation_token
  end
   
  def user_registration
      @user.save
      handle_invitation
      AppMailer.notify_on_new_user(@user).deliver
  end

  def handle_payment
    StripeWrapper::Charge.create(
      :amount => 999,
      :card => @token,
      :description => 'Myflix monthly service fee'
    )
  end

  def handle_invitation
    if @invitation_token.present?
      invitation = Invitation.where(token: @invitation_token).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end 
  end
end
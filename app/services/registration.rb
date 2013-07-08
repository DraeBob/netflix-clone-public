class Registration < Draper::Decorator
  delegate_all
  def initialize(user)
    @user = user
  end
   
  def registration_process
    handle_payment(@user)
    if @charge.successful?
      @user.save
      session[:user_id] = @user.id
      handle_invitation
      AppMailer.notify_on_new_user(@user).deliver
      flash[:success] = "Successfully registered"
      redirect_to videos_path
    else 
      flash[:error] = @charge.error_message
      render :new
    end
  end

  def handle_payment(user)
    token = params[:stripeToken]
    @charge = StripeWrapper::Charge.create(
      :amount => 999,
      :card => token,
      :description => 'Myflix monthly service fee'
    )
  end

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.where(token: params[:invitation_token]).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end 
  end
end
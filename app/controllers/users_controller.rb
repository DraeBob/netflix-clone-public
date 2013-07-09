class UsersController < ApplicationController
  before_filter :require_user, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def new
    redirect_to videos_path if current_user
    @user = User.new
  end

  def new_with_invitation_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation
      @user = User.new(email: invitation.friend_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(params[:user])
    token = params[:stripeToken]
    invitation_token = params[:invitation_token]

    if @user.valid?
      registration = Registration.new(@user, token, invitation_token)
      registration.handle_payment
      if registration.handle_payment.successful?
        registration.user_registration
        session[:user_id] = @user.id
        flash[:success] = "Successfully registered"
        redirect_to videos_path
      else 
        flash[:error] = registration.handle_payment.error_message
        render :new
      end
    else
      flash[:error] = 'Cannot create an user, check the input and try again'
      render :new
    end
  end
end
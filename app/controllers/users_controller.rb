class UsersController < ApplicationController
  before_filter :require_user, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def new
    redirect_to videos_path if current_user
    @user = User.new
    if params[:token] != nil
      invitation = Invitation.find_by_token(token)
      @user.email = @user.invitation.friend_email
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      AppMailer.notify_on_new_user(@user).deliver
      flash[:notice] = "Successfully registered"
      redirect_to videos_path
    else
      render :new
    end
  end
end
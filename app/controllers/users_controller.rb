class UsersController < ApplicationController
  before_filter :require_user, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def new
    redirect_to videos_path if current_user
    @invitation_id = params[:invitation_id] || nil
    if @invitation_id
      @email = Invitation.find(@invitation_id).friend_email
      @user = User.new(email: @email)
    else
      @user = User.new
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
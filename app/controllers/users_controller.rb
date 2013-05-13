class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user] = current_user
      flash[:notice] = "Successfully registered"
      redirect_to videos_path
    else
      render :new
    end
  end
end
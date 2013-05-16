class SessionsController < ApplicationController

  def index
  end

  def new
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome, you are logged in"
      redirect_to videos_path
    else
      flash[:error] = "Email or password is incorrect"
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You are logged out"
    redirect_to root_path
  end
end
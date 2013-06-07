class UsersController < ApplicationController
  before_filter :require_user, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def new
    redirect_to videos_path if current_user
    @user = User.new
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

  # def forgot_password
  # end

  def password_reset_token
    user = User.find_by_email(params[:email])
    if user
      user.token
      AppMailer.password_reset_confirmation(user).deliver
      redirect_to confirm_password_reset_path
    else
      flash[:error] = "Please enter correct email address."
      render :forgot_password
    end
  end

  # def confirm_password_reset
  # end

  def reset_password
  end

  def invalid_token
  end
end
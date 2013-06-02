class FollowershipsController < ApplicationController
  before_filter :require_user

  def show
    @followerships = current_user.followerships
  end

  def create
    @user = User.find(params[:id])
    if current_user != @user
      @followership = current_user.followerships.build(follower_id: params[:follower_id])
      @followership.save
      flash[:notice] = "Followership created"
      redirect_to followership_path(current_user)
    else
      flash[:error] = "You cannot follow yourself"
      render 'users/show'
    end
  end

  def destroy
    @followership = current_user.followerships.find(params[:id])
    @followership.destroy if current_user.followerships.include?(@followership)
    flash[:notice] = "Successfully deleted"
    redirect_to followership_path(current_user)
  end
end
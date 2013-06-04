class FollowershipsController < ApplicationController
  before_filter :require_user

  def index
    @followerships = current_user.following_relationships
  end

  def create
    followee = User.find(params[:followee_id])
    if current_user.can_follow?(followee)
      Followership.create(follower: current_user, followee: followee)
      flash[:notice] = "following relationships created"
      redirect_to followerships_path
    else
      flash[:error] = "You cannot follow yourself"
      render 'users/show'
    end
  end

  def destroy
    followership = Followership.find(params[:id])
    followership.destroy if current_user == followership.follower
    flash[:notice] = "Successfully deleted"
    redirect_to followerships_path
  end
end
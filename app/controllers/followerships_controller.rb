class FollowershipsController < ApplicationController
  before_filter :require_user

  def show
  end

  def create
    @followership = current_user.followerships.build(follower_id: params[:follower_id])
    if @followership.save
      flash[:notice] = "Followership created"
      redirect_to followership_path(current_user)
    else
      render 'users/show'
    end
  end

  def destroy

  end
end
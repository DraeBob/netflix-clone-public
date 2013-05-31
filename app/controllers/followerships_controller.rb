class FollowershipsController < ApplicationController
  before_filter :require_user

  def show
  end

  def create
    @followership = current_user.followerships.build(follower_id: params[:follower_id])
    if @followership.save
      flash[:notice] = "Followership created"
      redirect_to followership_path(current_user)
    # else
    #   flash[:error] = "Something went wrong, unable to add"
    #   render 'users/show'
    end
  end

  def destroy
    @followership = current_user.followerships.find(params[:id])
    @followership.destroy # if current_user.followerships.include?(@followership)
    flash[:notice] = "Successfully deleted"
    redirect_to followership_path(current_user)
  end
end
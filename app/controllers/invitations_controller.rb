class InvitationsController < ApplicationController
  before_filter :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(params[:invitation])
    @invitation.inviter = current_user
    
    if User.find_by_email(@invitation.friend_email) 
      flash[:error] = "You cannot invite friend who is already registered"
      render :new
    elsif  @invitation.friend_email == nil || @invitation.friend_email == ""
      flash[:error] = "Blank email"
      render :new
    else 
      if @invitation.save
        AppMailer.invite_friend(@invitation).deliver
        redirect_to root_path
        flash[:success] = "Invitation message has been sent to your friend"
      else
        render :new
      end 
    end 
  end
end

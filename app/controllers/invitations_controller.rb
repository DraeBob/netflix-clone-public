class InvitationsController < ApplicationController
  before_filter :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    invitation = Invitation.new(params[:invitation])
    invitation.inviter = current_user
    if invitation.save
      AppMailer.invite_friend(invitation).deliver
      flash[:success] = "Invitation message has been sent to your friend"
      redirect_to root_path
    else
      render :new
    end        
  end
end

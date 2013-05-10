class ApplicationController < ActionController::Base
  protect_from_forgery
  def require_user
    unless logged_in?
      flash[:error] = "You don't have permission to do this"
      redirect_to root_path
    end
  end
end

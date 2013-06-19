class AdminsController < AuthenticatedController
  before_filter :require_admin

  def require_admin
    flash[:error] = 'You do not have the permission to do this'
    redirect_to root_path unless current_user.admin?
end
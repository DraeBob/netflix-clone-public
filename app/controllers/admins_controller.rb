class AdminsController < AuthenticatedController
  before_filter :require_admin

  def require_admin
    if !current_user.admin?
      redirect_to root_path 
      flash[:error] = 'Non-admin users do not have the permission to do this'
    end 
  end
end
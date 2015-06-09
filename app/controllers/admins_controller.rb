class AdminsController < VideosController
  before_filter :require_admin

  def require_admin
    if !current_user.admin?
      flash[:error] = "You are not authorized to view this page"
      redirect_to home_path
    end
  end
end

class ApplicationController < ActionController::Base
  before_action :current_user
  before_action :ensure_user_logged_in

  def ensure_user_logged_in
    unless current_user
      redirect_to "/login"
    end
  end

  def limit_access_to(roles)
    unless @current_user && roles.index(@current_user.role)
      flash[:error] = ["You don't have enough permissions"]
      return redirect_to "/dashboard"
    end
  end

  def current_user
    return @current_user if @current_user
    current_user_id = session[:current_user_id]
    if current_user_id
      @current_user = User.find(current_user_id)
    end
    @current_user
  end
end

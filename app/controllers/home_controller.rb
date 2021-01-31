class HomeController < ApplicationController
  before_action :ensure_user_logged_in, only: [:dashboard]

  def index
    render "Home/index", :locals => { menu_items: MenuItem.get_active }
  end

  def login
    render "users/login", :layout => "form_layout"
  end

  def signup
    render "users/signup", :layout => "form_layout"
  end

  def dashboard
    render "Home/dashboard"
  end
end

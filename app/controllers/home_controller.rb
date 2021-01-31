class HomeController < ApplicationController
  before_action :ensure_user_logged_in, only: [:dashboard]

  def login
    render "users/login", :layout => "form_layout"
  end

  def signup
    render "users/signup", :layout => "form_layout"
  end

  def dashboard
    render "home/dashboard"
  end
end

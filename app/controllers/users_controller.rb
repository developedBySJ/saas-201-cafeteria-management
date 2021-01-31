class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in, only: [:login, :create]
  before_action except: [:login, :create, :logout, :show, :edit] do
    limit_access_to(["admin"])
  end

  def index
    users = User.all
    render "users/index", :locals => { users: users }
  end

  def show
    id = params[:id]
    pp @current_user
    pp @current_user.id
    pp id
    if (@current_user.role == "admin" || @current_user.id.to_s == id)
      user = User.find(id)
      render "users/show", :locals => { user: user }
    else
      redirect_to user_path(@current_user.id)
    end
  end

  def destroy
    if @current_user.role == "admin"
      id = params[:id]
      user = User.find(id)
      user.destroy
      flash[:success] = ["Deleted user with id #{id}"]
      redirect_to users_path
    else
      flash[:success] = ["You don't have enough permissions"]
      redirect_to "/dashboard"
    end
  end

  def edit
    id = params[:id]
    if (@current_user.role == "admin" || @current_user.id.to_s == id)
      user = User.find(id)
      render "users/edit", :locals => { user: user }
    else
      redirect_to edit_user_path(@current_user.id)
    end
  end

  def new
  end

  def update
    id = params[:id]
    if (@current_user.role == "admin" || @current_user.id.to_s == id)
      user = User.find(id)
      user.first_name = params[:first_name]
      user.last_name = params[:last_name]
      user.password = params[:password] if params[:password]
      user.role = params[:role] if (params[:role] && @current_user.role == "admin")
      if user.save
        flash[:success] = ["Profile updated successFully"]
        redirect_to user_path(user.id)
      else
        error = user.errors.full_messages
        flash[:error] = error[0...3]
        redirect_to edit_user_path(user.id)
      end
    else
      flash[:error] = ["You don't have enough permissions"]
      redirect_to edit_user_path(@current_user.id)
    end
  end

  def create
    email = params[:email]
    is_existing_user = User.find_by(email: email)
    if is_existing_user
      return render plain: "email already exist! please login to continue."
    end

    new_user = User.new({
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: email,
      password: params[:password],
      role: @current_user.role == "admin" ? params[:role] : "customer",
    })

    if new_user.save
      if !@current_user.role == "admin"
        session[:current_user_id] = new_user.id
        redirect_to "/"
      else
        flash[:success] = ["User Created Successfully"]
        redirect_to users_path
      end
    else
      error = new_user.errors.full_messages
      flash[:error] = error[0...3]
      if !@current_user.role == "admin"
        redirect_to signup_path
      else
        redirect_to new_user_path
      end
    end
  end

  def login
    user = User.find_by email: params[:email]
    if user && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      redirect_to "/"
    else
      flash[:error] = ["Invalid email or password!"]
      redirect_to login_path
    end
  end

  def logout
    session[:current_user_id] = nil
    @current_user = nil
    redirect_to "/"
  end
end

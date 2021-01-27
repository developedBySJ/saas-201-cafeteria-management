class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in, only: [:login, :create]
  skip_before_action :verify_authenticity_token

  def index
    render plain: User.all.map { |user| user.to_string }.join("\n")
  end

  def show
    id = params[:id]
    user = User.find(id)
    render plain: user.to_string
  end

  def destroy
    if @current_user.role == "admin"
      id = params[:id]
      user = User.find(id)
      user.destroy
      render plain: "deleted user with id #{id}"
    else
      render plain: "forbidden"
    end
  end

  def update
    id = params[:id]
    if @current_user && (@current_user.role == "admin" || @current_user.id = id)
      user = User.find(id)
      user.update({
        first_name: params[:first_name],
        last_name: params[:last_name],
        password: params[:password],
      })

      render plain: user.to_string
    else
      render plain: "forbidden"
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
      role: "customer",
    })

    if new_user.save
      session[:current_user_id] = new_user.id
      render plain: new_user.to_string
    else
      render plain: new_user.errors.full_messages.join("|")
    end
  end

  def login
    user = User.find_by email: params[:email]
    if user && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      render plain: user.to_string
    else
      render plain: "Invalid email or password!"
    end
  end
end

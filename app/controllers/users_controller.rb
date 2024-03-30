class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to messages_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def require_login
    unless session[:user_id]
      redirect_to login_users_path, alert: 'You must be logged in to access this page.'
    end
  end

  def login
    @user = User.new
  end

  # Secure login functionality
  def authenticate
    @user = User.find_by(username: params[:username])
    
    if @user && @user.authenticate(params[:password])
      log_authentication_attempt(params[:username], true)
      session[:user_id] = @user.id
      redirect_to messages_path, notice: "Logged in successfully as #{params[:username]}."
    else
      log_authentication_attempt(params[:username], false)
      redirect_to login_users_path, alert: "Invalid username or password for #{params[:username]}."
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_users_path, notice: 'Logged out successfully.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password, :email)
  end
end

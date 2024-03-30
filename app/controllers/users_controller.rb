class UsersController < ApplicationController
    def new
        @user = User.new
      end
    
      def create
        @user = User.new(user_params)
        @user.password_digest = params[:user][:password]
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
      
      # Login functionality with sql injection flaw
      def authenticate
        # Check if username and password are present
        if params[:username].present? && params[:password].present?
          username = params[:username]
          password = params[:password]
          
          # Construct the SQL query with injected parameters
          sql = "SELECT * FROM users WHERE username = '#{username}' AND password_digest = '#{password}'"
          
          # Logging the SQL query for debugging
          Rails.logger.info "SQL Query: #{sql}"
          
          @user = User.find_by_sql(sql).first
          
          if @user
            session[:user_id] = @user.id
            redirect_to messages_path, notice: "Logged in successfully as #{username}."
          else
            redirect_to login_users_path, alert: "Invalid username or password for #{username}."
          end
        else
          redirect_to login_users_path, alert: "Username and password cannot be blank."
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
      params.require(:user).permit(:username, :password, :email) # Remove :password_digest
    end
  end
  
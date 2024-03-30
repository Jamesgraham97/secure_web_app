class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update]
  
  def index
    @messages = Message.where(user_id: session[:user_id])
    @user = User.find_by(id: session[:user_id])
    redirect_to login_users_path, alert: 'You must be logged in to access this page.' unless @user
  end

  def show
    @message = Message.find(params[:id])
    # Escaping the message content to prevent XSS attacks
    @escaped_content = ERB::Util.html_escape(@message.content)
  end
  
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params.merge(user_id: session[:user_id]))
    
    if @message.save
      redirect_to @message, notice: "Message was successfully created."
    else
      render :new
    end
  end
  
  def edit
    @message = Message.find(params[:id])
  end
  
  def update
    if @message.update(message_params)
      redirect_to messages_path, notice: 'Message was successfully updated.'
    else
      render :edit
    end
  end
  
  private
  
  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end

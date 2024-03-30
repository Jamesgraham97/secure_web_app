class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update]
  
  def index
    @messages = Message.where(user_id: session[:user_id])
    @user = User.find(session[:user_id])
  end
  # xss flaw to render t he mesage without escaping it 
  def show
    @message = Message.find(params[:id])
  end
  
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params.merge(user_id: session[:user_id]))
    
    if @message.save
      redirect_to @message, notice: "Message '#{params[:content]}' was successfully created."
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

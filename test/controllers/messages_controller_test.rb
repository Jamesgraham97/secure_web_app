require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do
    @user = User.create(username: "test_user", password_digest: "password", email: "test@example.com") 
    session[:user_id] = @user.id
    @message = Message.create(content: "Test message content", user_id: @user.id)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
    assert_equal @user.id, assigns(:user).id
  end

  test "should show message" do
    get :show, params: { id: @message.id }
    assert_response :success
  end


  test "should render message content without escaping (XSS flaw)" do
    malicious_content = "<script>alert('XSS')</script>"
    message = Message.create(content: malicious_content, user_id: @user.id)
    get :show, params: { id: message.id }
    assert_match malicious_content, response.body
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:message)
  end

  test "should create message" do
    assert_difference('Message.count') do
      post :create, params: { message: { content: 'Hello, world!' } }
    end

    assert_redirected_to message_path(assigns(:message))
  end

  test "should render new template for invalid message" do
    post :create, params: { message: { content: nil } }
    assert_template :new
  end

  test "should get edit" do
    get :edit, params: { id: @message.id }
    assert_response :success
    assert_not_nil assigns(:message)
  end


  test "should update message" do
    patch :update, params: { id: @message.id, message: { content: 'Updated content' } }
    assert_redirected_to messages_path
    assert_equal 'Message was successfully updated.', flash[:notice]
  end

  test "should render edit template for invalid update" do
    patch :update, params: { id: @message.id, message: { content: nil } }
    assert_template :edit
  end

  

end

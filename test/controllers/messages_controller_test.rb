require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do
    @user = User.create(username: "test_user", password: "password", email: "test@example.com")
    session[:user_id] = @user.id
  end

  # Normal Flow

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
  end

  test "should get show" do
    message = Message.create(content: "Test message", user_id: @user.id)
    get :show, params: { id: message.id }
    assert_response :success
    assert_equal "Test message", assigns(:escaped_content)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:message)
  end

  test "should create message" do
    assert_difference('Message.count') do
      post :create, params: { message: { content: 'New test message' } }
    end

    assert_redirected_to message_path(assigns(:message))
    assert_equal 'Message was successfully created.', flash[:notice]
  end

  test "should get edit" do
    message = Message.create(content: "Test message", user_id: @user.id)
    get :edit, params: { id: message.id }
    assert_response :success
    assert_equal "Test message", assigns(:message).content
  end

  test "should update message" do
    message = Message.create(content: "Test message", user_id: @user.id)
    patch :update, params: { id: message.id, message: { content: 'Updated test message' } }
    assert_redirected_to messages_path
    assert_equal 'Message was successfully updated.', flash[:notice]
  end

  # Alternate Flow

  test "should not create message with invalid params" do
    assert_no_difference('Message.count') do
      post :create, params: { message: { content: nil } }
    end

    assert_template :new
  end

  test "should not update message with invalid params" do
    message = Message.create(content: "Test message", user_id: @user.id)
    patch :update, params: { id: message.id, message: { content: nil } }
    assert_template :edit
  end

  # Exception Flow

  test "should redirect to login page if user is not logged in for index" do
    session[:user_id] = nil
    get :index
    assert_redirected_to login_users_path
    assert_equal 'You must be logged in to access this page.', flash[:alert]
  end

  
end

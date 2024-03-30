require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do
    @user = User.create(username: "test_user", password_digest: "password", email: "test@example.com")
    session[:user_id] = @user.id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
  end

  test "should create message" do
    assert_difference('Message.count') do
      post :create, params: { message: { content: 'Hello, world!' } }
    end

    assert_redirected_to message_path(assigns(:message))
  end

  test "should show message with XSS flaw" do
    message = Message.create(content: "<script>alert('XSS Attack');</script>", user: @user)
    get :show, params: { id: message.id }
    assert_response :success
    assert_match /<script>alert\('XSS Attack'\);<\/script>/, response.body
  end

  test "should not save message without content" do
    assert_no_difference('Message.count') do
      post :create, params: { message: { content: '' } }
    end
    assert_template :new
  end
end

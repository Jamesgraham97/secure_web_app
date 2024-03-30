require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username: "test_user", password_digest: "password", email: "test@example.com")
  end

  test "should authenticate user with valid credentials" do
    post authenticate_users_path, params: { username: @user.username, password: "password" }
    assert_redirected_to messages_path
    assert_equal session[:user_id], @user.id
  end

  test "should not authenticate user with invalid credentials" do
    post authenticate_users_path, params: { username: @user.username, password: "wrong_password" }
    assert_redirected_to login_users_path
    assert_nil session[:user_id]
  end
  test "should handle empty username or password fields" do
    post authenticate_users_url, params: { username: '', password: '' }
    assert_redirected_to login_users_path
    assert_equal 'Username and password cannot be blank.', flash[:alert]
  end

  test "should authenticate user with SQL injection" do
  post authenticate_users_url, params: { username: "' OR '1'='1", password: "' OR '1'='1" }
  assert_redirected_to messages_path
  assert_equal "Logged in successfully as ' OR '1'='1.", flash[:notice]
end

  
end

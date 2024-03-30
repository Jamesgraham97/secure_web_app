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

  test "should authenticate user with SQL injection" do
    post authenticate_users_path, params: { username: "1' OR '1'='1'", password: "1' OR '1'='1'" }
    
    # Check if the user was redirected to the messages page due to successful authentication
    assert_redirected_to messages_path
    
    # Check if the session has a user_id set
    assert_not_nil session[:user_id], "Session should have a user_id"
    
    # Fetch the user based on the session user_id and check if it matches the expected username
    user = User.find(session[:user_id])
    assert_equal "1' OR '1'='1'", user.username, "User should have the injected username"
  end
  
  
end

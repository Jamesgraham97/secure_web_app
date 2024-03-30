require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = User.create(username: "test_user", password: "password", email: "test@example.com") 
    session[:user_id] = @user.id
  end

  # Normal Flow

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, params: { user: { username: 'new_user', password: 'password', email: 'new_user@example.com' } }
    end

    assert_redirected_to messages_path
    assert_equal 'User was successfully created.', flash[:notice]
  end

  test "should login user" do
    post :authenticate, params: { username: @user.username, password: 'password' }  # Use the correct password 'password'
    
    assert_redirected_to messages_path
    assert_equal "Logged in successfully as #{@user.username}.", flash[:notice]
    assert_not_nil session[:user_id]  # Ensure session is set
  end
  
  
  
  
  
   

  test "should logout user" do
    get :logout
    assert_redirected_to login_users_path
    assert_equal 'Logged out successfully.', flash[:notice]
  end

  # Alternate Flow

  test "should not create user with invalid params" do
    assert_no_difference('User.count') do
      post :create, params: { user: { username: nil, password: nil, email: nil } }
    end

    assert_template :new
  end

  test "should not login user with invalid credentials" do
    post :authenticate, params: { username: @user.username, password: 'wrong_password' }
    assert_redirected_to login_users_path
    assert_equal "Invalid username or password for #{@user.username}.", flash[:alert]
  end

end

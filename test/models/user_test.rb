require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save user without username" do
    user = User.new(password: "password", email: "test@example.com")
    assert_not user.save, "Saved the user without a username"
  end

  test "should not save user without password" do
    user = User.new(username: "test_user", email: "test@example.com")
    assert_not user.save, "Saved the user without a password"
  end

  test "should not save user without email" do
    user = User.new(username: "test_user", password: "password")
    assert_not user.save, "Saved the user without an email"
  end

  test "should save valid user" do
    user = User.new(username: "test_user", password: "password", password_confirmation: "password", email: "test@example.com")
    assert user.save, "Could not save the valid user"
  end

  test "should have many messages" do
    user = User.reflect_on_association(:messages)
    assert_equal :has_many, user.macro
  end
end

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @user = User.create(username: "test_user", password_digest: "password", email: "test@example.com")
  end

  test "should save valid message" do
    message = Message.new(content: "Hello, world!", user: @user)
    assert message.save, "Could not save the valid message"
  end

  test "should not save message without content" do
    message = Message.new(user: @user)
    assert_not message.save, "Saved the message without content"
    assert_equal ["can't be blank"], message.errors[:content]
  end
  
  test "should belong to user" do
    assert_equal @user, Message.new(content: "Hello, world!", user: @user).user, "Message does not belong to correct user"
  end
end

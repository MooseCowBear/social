require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  setup do
    @notification = Notification.first
  end

  test "belongs to user" do 
    assert @notification.user
  end

  test "belongs to item" do
    assert @notification.item
  end

  test "unread scope returns correct number of notifications" do
    n = Notification.unread
    assert_equal 1, n.size
  end
end

require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
   @user = users(:alice)
  end

  test "has one profile" do
    assert @user.profile
  end

  test "has posts" do
    assert @user.posts
  end

  test "has potential friends" do
    assert @user.potential_friends
  end

  test "has likes" do
    assert @user.likes
  end

  test "has comments" do
    assert @user.comments
  end

  test "has notifications" do
    assert @user.notifications
  end

  test "has friend requests" do
    assert @user.friend_requests
  end

  test "has received requests" do 
    assert @user.received_requests
  end

  test "has correct number of friends" do
    assert_equal 1, @user.friends.size
  end

  test "has correct number of requested friends" do
    assert_equal 1, @user.requested_friends.size
  end 

  test "has correct number of pending friends" do
    assert_equal 1, @user.pending_friends.size
  end

  test "has correct number of declined friends" do
    assert_equal 1, @user.declined_friends.size
  end

  test "has correct number of potential friends" do
    assert_equal 4, @user.potential_friends.size
  end

  test "has correct number of non potential friends returned in all except scope" do
    assert_equal 2, User.all_except(@user).size
  end

  test "#friend_with? returns false when user is not friends with other" do
    other = users(:charlie)
    assert_not @user.friend_with?(other)
  end

  test "#friend_with? returns true when user is friends with other" do
    other = users(:bob)
    assert @user.friend_with?(other)
  end

  test "#post_like returns like if user has liked post" do
    post = posts(:one)
    assert @user.post_like(post.id)
  end

  test "#post_like returns nil if user has not liked post" do
    post = posts(:two)
    assert_not @user.post_like(post.id)
  end

  test "#get_time_zone returns time zone from profile if profile" do
    assert_equal "International Date Line West", @user.get_time_zone
  end

  test "#get_time_zone returns eastern if no profile" do
    user = users(:bob)
    assert_equal "Eastern Time (US & Canada)", user.get_time_zone
  end
end

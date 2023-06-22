require "test_helper"

class FriendRequestTest < ActiveSupport::TestCase
  setup do
    @user = users(:alice)
  end
  
  test "user cannot send friend request to self" do
    request = FriendRequest.send_request(@user, @user)
    assert_not request
  end

  test "user cannot send friend request if already sent" do
    friend = users(:bob)
    request = FriendRequest.send_request(@user, friend)
    assert_not request
  end

  test "user can send friend request if none exists" do
    friend = users(:charlie)
    request = FriendRequest.send_request(@user, friend)
    assert request
  end

  test "cannot accept request that does not exist" do
    friend = users(:gary)
    res = FriendRequest.accept_request(@user, friend)
    assert_not res
  end

  test "cannot decline request that does not exist" do
    friend = users(:gary)
    res = FriendRequest.decline_request(@user, friend)
    assert_not res
  end

  test "cannot unfriend if request does not exist" do
    friend = users(:gary)
    res = FriendRequest.unfriend(@user, friend)
    assert_not res
  end 

  test "can decline a pending request" do
    friend = users(:david)
    FriendRequest.decline_request(@user, friend)
    assert_equal friend_requests(:four).status, "declined"
  end

  test "can accept a pending request" do
    friend = users(:david)
    FriendRequest.accept_request(@user, friend)
    assert_equal friend_requests(:four).status, "accepted"
    assert_equal friend_requests(:three).status, "accepted"
  end

  test "can unfriend" do
    friend = users(:bob)
    assert_difference("FriendRequest.count", -2) do
      FriendRequest.unfriend(@user, friend)
    end
  end

  test "recipients list of friend request consists of receiver of request" do
    friend = users(:charlie)
    request = FriendRequest.send_request(@user, friend)
    assert_equal request.recipients.length, 1
    assert request.recipients.include?(friend.id)
  end
end

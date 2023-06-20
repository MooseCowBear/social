require "test_helper"

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:alice)
  end

  test "gets index" do
    get friend_requests_path
    assert_response :success
  end

  test "creates new friend request" do
    friend = users(:gary)
    assert_difference("FriendRequest.count", 2) do
      post friend_requests_path, params: { friend: friend.id }
    end
    assert_response :redirect
    follow_redirect!
    assert_equal "Your request has been sent.", flash[:notice]
  end

  test "accepts friend request" do
    friend = users(:frank)
    post accept_friend_requests_path, params: { friend: friend.id }
    fr = FriendRequest.find_by(user_id: friend.id, friend_id: users(:alice).id)
    fr2 = FriendRequest.find_by(user_id: users(:alice).id, friend_id: friend.id)
    assert_response :redirect
    assert_equal fr.status, "accepted"
    assert_equal fr2.status, "accepted"
  end

  test "rejects friends request" do
    friend = users(:frank)
    post decline_friend_requests_path, params: { friend: friend.id }
    fr = FriendRequest.find_by(user_id: users(:alice).id, friend_id: friend.id)
    assert_response :redirect
    assert_equal fr.status, "declined"
  end
end

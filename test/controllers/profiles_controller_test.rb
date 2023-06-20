require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:alice)
  end

  test "should get profile show" do
    get user_profile_path(user_id: users(:alice).id, id: profiles(:alice_profile).id)
    assert_response :success
  end

  test "should get new" do
    get new_user_profile_path(user_id: users(:alice).id)
    assert_response :success
  end

  test "should create a profile for current user" do
    user = users(:bob)
    sign_in user
    assert_difference("Profile.count", 1) do 
      post profiles_path, 
        params: { profile: { username: "bobisthebest", user_id: user.id } }
    end
    assert_response :redirect
    follow_redirect!
  end

  test "should allow profile owner to update" do
    patch profile_path(id: profiles(:alice_profile)), 
      params: { profile: { username: "alice's new username"} }
    assert_response :redirect
    follow_redirect!
    assert_equal "Profile has been updated.", flash[:notice]
  end

  test "should allow profile owner to delete" do
    assert_difference("Profile.count", -1) do 
      delete profile_path(id: profiles(:alice_profile))
    end
    assert_response :redirect
    follow_redirect!
  end

  test "should not allow user to edit profile not belonging to them" do
    patch profile_path(id: profiles(:charlie_profile)), 
      params: { profile: { username: "butthead"} }
    assert_response :redirect
    follow_redirect!
    assert_equal "Only profile owners may edit profiles.", flash[:notice]
  end

  test "should not allow user to delete profile not belonging to them" do
    assert_no_difference("Profile.count") do
      delete profile_path(id: profiles(:charlie_profile))
    end
    assert_response :redirect
    follow_redirect!
    assert_equal "Only profile owners may edit profiles.", flash[:notice]
  end
end

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:alice)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end
  
  test "should get show for self" do
    get user_path(users(:alice).id)
    assert_response :success
  end

  test "should get show for friend" do
    get user_path(users(:bob).id)
    assert_response :success
  end

  test "should redirect if try to view page for non-friend" do
    get user_path(users(:gary).id)
    assert_response :redirect
    assert_redirected_to root_path
  end

  
end

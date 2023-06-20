require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "redirects to log in page if user is not signed in" do
    get "/"
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test "redirects to user's show page if signed in" do
    sign_in users(:alice)

    get "/"
    assert_response :redirect
    assert_redirected_to user_path(users(:alice).id)
  end
end

require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:alice)
  end

  test "should get index" do
    get notifications_path
    assert_response :success
  end
end

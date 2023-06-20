require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get not_found" do
    get "/404"
    assert_response :redirect
  end

  test "should get server_error" do
    get "/500"
    assert_response :redirect
  end

  test "should get unprocessable_content" do
    get "/422"
    assert_response :redirect
  end
end

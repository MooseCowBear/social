require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::ControllerHelpers
  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in users(:alice)
  end

  
end

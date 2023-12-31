require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  setup do
    @user = users(:frank)
  end
  
  test "does not create profile if username is more than 20 chars" do
    profile = Profile.new
    profile.user = @user
    profile.username = "a" * 21

    assert_not profile.save
  end

  test "does not create profile if username already exists" do
    profile = Profile.new
    profile.user = @user
    profile.username = "alice's username"

    assert_not profile.save
  end

  test "creates profile if username unique" do
    profile = Profile.new
    profile.user = @user
    profile.username = "unique username"

    assert profile.save
  end
end

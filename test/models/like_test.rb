require "test_helper"

class LikeTest < ActiveSupport::TestCase
  
  setup do 
    @like = Like.last
  end

  test "belongs to user" do
    assert @like.user
  end

  test "has notificaitons" do
    assert @like.notifications
  end

  test "belongs to post" do
    assert @like.post
  end
end

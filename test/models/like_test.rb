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

  test "does not create new like when user has already liked a post" do
    post = Post.find(1)
    user = users(:alice)
    like = Like.new
    like.post = post
    like.user = user

    assert_not like.save
  end

  test "creates new like when user has not already liked a post" do
    post = Post.find(1)
    user = users(:bob)
    like = Like.new
    like.post = post
    like.user = user

    assert like.save
  end
end

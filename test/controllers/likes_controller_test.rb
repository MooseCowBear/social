require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:alice)
    @post = Post.find(3)
  end

  test "should create like" do
    assert_difference("Like.count", 1) do
      post post_likes_path(post_id: @post.id), params: { post_id: @post.id }
    end
    assert_response :redirect
    follow_redirect!
    assert_equal "Post has been liked.", flash[:notice]
  end

  test "should delete like" do 
    post = Post.find(1)
    assert_difference("Like.count", -1) do
      delete post_like_path(post_id: post.id, id: likes(:one).id)
    end
    assert_response :redirect
    follow_redirect!
    assert_equal "Post has been unliked.", flash[:notice]
  end
end

require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:alice)
    @post = Post.first
    @comment = Comment.last
  end

  test "should get new post comment" do
    get new_post_comment_path(@post)
    assert_response :success
  end

  test "should get edit of post comment" do
    get edit_post_comment_path(post_id: 1, id: comments(:comment_one).id)
    assert_response :success
  end

  test "should create post comment" do
    assert_difference("Comment.count", 1) do
      post post_comments_path(@post), params: { post_id: @post.id, comment: { body: "some content", parent_post_id: @post.id } }
    end
    assert_response :redirect
    follow_redirect!
    assert_select "p", "some content"
  end

  test "should update post comment" do
    patch post_comment_path(post_id: @post.id, id: comments(:comment_one).id), params: { post_id: @post.id, comment: { body: "some new content", parent_post_id: @post.id } }
    assert_response :redirect
    follow_redirect!
    assert_select "p", "some new content"
  end

  test "should delete comment, and any of its comments" do
    assert_difference("Comment.count", -2) do 
      delete comment_path(comments(:comment_one))
    end
    assert_response :redirect
    follow_redirect!
  end

  test "should get new comment comment" do
    get new_comment_comment_path(@comment, parent_post_id: 1)
    assert_response :success
  end

  test "should get edit of comment comment" do
    get edit_comment_comment_path(comment_id: comments(:comment_one), id: @comment.id)
    assert_response :success
  end

  test "should create comment comment" do
    assert_difference("Comment.count", 1) do
      post comment_comments_path(comment_id: comments(:comment_one)), params: { comment_id: comments(:comment_one), comment: { body: "some content", parent_post_id: @post.id } }
    end
    assert_response :redirect
    follow_redirect!
    assert_select "p", "some content"
  end

  test "should update comment comment" do
    patch comment_comment_path(comment_id: comments(:comment_one).id, id: @comment), params: { comment_id: comments(:comment_one).id, comment: { body: "some new content", parent_post_id: @post.id } }
    assert_response :redirect
    follow_redirect!
    assert_select "p", "some new content"
  end
end

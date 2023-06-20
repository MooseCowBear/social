require "test_helper"

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @comment = Comment.last
  end

  test "belongs to user" do
    assert @comment.user
  end

  test "has comments" do
    assert @comment.comments
  end

  test "belongs to commentable" do
    assert @comment.commentable
  end

  test "has notifications" do
    assert @comment.notifications
  end

  test "has ancestor post" do
    assert @comment.ancestor_post
  end

  test "creates comment when body present" do
    comment = Comment.new
    comment.user = users(:bob)
    comment.commentable = comments(:comment_two)
    comment.parent_post_id = 1
    comment.body = "something"

    assert comment.save
  end

  test "does not create comment when body missing" do
    comment = Comment.new
    comment.user = users(:bob)
    comment.commentable = comments(:comment_two)
    comment.parent_post_id = 1

    assert_not comment.save
  end
end

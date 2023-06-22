require "test_helper"

class CommentTest < ActiveSupport::TestCase
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

  test "when a reply is made, original comment author is in notification recipient list" do
    comment = Comment.new
    comment.user = users(:frank)
    comment.commentable = comments(:comment_two)
    comment.parent_post_id = 1
    comment.body = "something"
    comment.save!

    assert comment.recipients.include?(users(:bob).id)
  end

  test "except when that user is repying to own comment" do
    comment = Comment.new
    comment.user = users(:bob)
    comment.commentable = comments(:comment_two)
    comment.parent_post_id = 1
    comment.body = "something"
    comment.save!

    assert_not comment.recipients.include?(users(:bob).id)
  end

  test "post author is in notification recipient list when someone comments on their post" do
    comment = Comment.new
    comment.user = users(:frank)
    comment.commentable = comments(:comment_two)
    comment.parent_post_id = 1
    comment.body = "something"
    comment.save!

    assert comment.recipients.include?(users(:alice).id)
  end

  test "except when author is also commenter" do
    comment = Comment.new
    comment.user = users(:alice)
    comment.commentable = comments(:comment_two)
    comment.parent_post_id = 1
    comment.body = "something"
    comment.save!

    assert_not comment.recipients.include?(users(:alice).id)
  end

  test "returns correct ancestor post" do
    assert_equal @comment.ancestor_post, Post.find(1)
  end
end
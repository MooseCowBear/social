require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  setup do
    @notification = Notification.first
  end

  test "belongs to user" do 
    assert @notification.user
  end

  test "belongs to item" do
    assert @notification.item
  end

  test "unread scope returns correct number of notifications" do
    n = Notification.unread
    assert_equal 1, n.size
  end

  test "number of notifications does not change if item is updated" do
    assert_no_difference("Notification.count") do
      post = Post.find(1)
      post.update!(title: "first post, edited", body: "first post body, edited")
    end
  end

  test "correct number of notifications are created when new post" do
    assert_difference("Notification.count", 1) do
      user = users(:alice)
      user.posts.create!(title: "a new post!", body: "with some content")
    end
  end

  test "correct number of notifications are created when post liked" do
    assert_difference("Notification.count", 1) do
      post = Post.find(1)
      user = users(:bob)
      like = Like.new
      like.post = post
      like.user = user
      like.save!
    end
  end

  test "correct number of notifications when comment on post" do
    assert_difference("Notification.count", 1) do
      comment = Comment.new
      comment.user = users(:frank)
      comment.commentable = Post.find(1)
      comment.parent_post_id = 1
      comment.body = "something"
      comment.save!
    end
  end

  test "correct number of notifications when reply to comment" do
    assert_difference("Notification.count", 2) do
      comment = Comment.new
      comment.user = users(:frank)
      comment.commentable = comments(:comment_two)
      comment.parent_post_id = 1
      comment.body = "something"
      comment.save!
    end
  end
end

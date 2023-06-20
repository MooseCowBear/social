require "test_helper"

class PostTest < ActiveSupport::TestCase
  
  setup do 
    @post = Post.first
  end

  test "belongs to user" do
    assert @post.user
  end

  test "has comments" do
    assert @post.comments
  end

  test "has notifications" do
    assert @post.notifications
  end

  test "has likes" do
    assert @post.likes
  end

  test "has descendants" do
    assert @post.descendants
  end

  test "has the correct number of descendants" do
    assert_equal 2, @post.descendants.size
  end
end

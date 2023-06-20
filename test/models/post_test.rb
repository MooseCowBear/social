require "test_helper"

class PostTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess::FixtureFile
  
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

  test "does not create post if no title" do
    new_post = Post.new
    new_post.body = "stuff"
    new_post.user = users(:alice)

    assert_not new_post.save
  end

  test "does not create post if no content" do
    new_post = Post.new
    new_post.title = "stuff"
    new_post.user = users(:alice)

    assert_not new_post.save
  end

  test "creates post if title and body" do
    new_post = Post.new
    new_post.title = "title"
    new_post.body = "stuff"
    new_post.user = users(:alice)

    assert new_post.save
  end

  test "creates post if title and image" do
    new_post = Post.new
    new_post.title = "title"
    new_post.user = users(:alice)
    new_post.image = fixture_file_upload("branch.jpeg", "image/jpeg")

    assert new_post.save
  end

  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end
end

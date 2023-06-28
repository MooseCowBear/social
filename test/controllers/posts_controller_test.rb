require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:alice)
  end

  test "should get index" do
    get posts_path
    assert_response :success
  end

  test "should get new" do
    get new_post_path
    assert_response :success
  end

  test "should get edit of own post" do
    get edit_post_path(1)
    assert_response :success
  end

  test "should not get edit of other's post" do
    get edit_post_path(3)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should get show for own post" do
    get post_path(1)
    assert_response :success
  end

  test "should get show for friend's post" do
    get post_path(2)
    assert_response :success
  end

  test "should not get post of non-friend" do
    get post_path(3)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create user post" do
    assert_difference("Post.count") do
      post posts_path, 
        params: { post: { title: "new post title", 
          body: "new post body", user_id: users(:alice).id } }
    end
    assert_response :redirect
    follow_redirect!
    assert_select "h2", "new post title" 
  end

  test "should update user's post" do
    patch post_path(1), params: { post: { title: "this is the new title", 
      body: "this is the new post body", user_id: users(:alice).id } }
    assert_response :redirect
    follow_redirect!
    assert_select "h2", "this is the new title"
  end

  test "should not update post not owned by user" do
    patch post_path(2), params: { post: { title: "updated title", 
      body: "updated body", user_id: users(:bob).id } }
    assert_response :redirect
    follow_redirect!
    assert_equal "Only the creators of a post may modify it.", flash[:alert]
  end

  test "should delete user's post" do
    assert_difference("Post.count", -1) do
      delete post_path(1)
    end
    assert_response :redirect
    follow_redirect!
  end

  test "should not delete another user's post" do
    assert_no_difference("Post.count") do
      delete post_path(3)
    end
  end

  test "should allow user to delete image from post if there is a body" do
    #giving the post an image to delete...
    #tried to add with active_storage/blob and attachment
    #but even though it created the attachment, calling Post.find(1).image.attached? 
    #returned false
    Post.find(1).image.attach(io: File.open('test/fixtures/files/branch.jpeg'), filename: 'branch.jpeg')

    patch post_path(1), params: { post: { remove_image: "1" } }
    
    assert_response :redirect
    follow_redirect!
    assert_not Post.find(1).image.attached?
  end

  test "should not allow user to delete image if there is no body" do
    Post.find(1).image.attach(io: File.open('test/fixtures/files/branch.jpeg'), filename: 'branch.jpeg')

    patch post_path(1), params: { post: { body: "", remove_image: "1" } }

    assert_match "Post must have content.", @response.body
    assert Post.find(1).image.attached?
  end
end

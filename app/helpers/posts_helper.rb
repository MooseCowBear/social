module PostsHelper
  def get_likes_count(post)
    begin 
      post.like_count
    rescue NoMethodError
      post.likes.size
    end
  end

  def get_comments_count(post)
    begin
      post.comment_count
    rescue NoMethodError
      post.descendants.size
    end
  end
end

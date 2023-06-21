module PostsHelper
  def get_likes_count(post)
    begin 
      post.like_count
    rescue NoMethodError
      puts "i am returning post.likes.size"
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

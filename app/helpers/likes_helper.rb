module LikesHelper
  def liked?(post)
    !!post.likes.find_by(user_id: current_user.id)
  end
end

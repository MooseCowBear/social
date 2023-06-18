class UsersController < ApplicationController
  def index
    @users = User.search(search_params, current_user)
  end

  def show
    @user = User.find(params[:id])
    @friends = @user.friends.includes(:profile)
    
    if @user == current_user
      @posts = Post.find_posts_with_counts(post_ids(@user))
    elsif @user.friend_with?(current_user)
      @posts = Post.find_posts_with_counts(@user.id)
    else
      redirect_to root_path, notice: "You may only view page's of friends."
    end
  end

  private

  def post_ids(user) 
    user.friends.pluck(:id) << user.id
  end

  def search_params
    params.permit(:query)
  end
end

class UsersController < ApplicationController
  def index
    @users = User.all_except(current_user).includes([:profile])
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(user_id: post_ids).includes([:user]).includes([:image_attachment])
  end

  private

  def post_ids
    current_user.friends.pluck(:id) << current_user.id
  end
end

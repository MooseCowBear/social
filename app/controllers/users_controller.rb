class UsersController < ApplicationController
  def index
    @users = User.all_except(current_user).includes([:profile]).order(:email) #is this what we want?
  end

  def show
    @user = User.find(params[:id])
    if @user == current_user
      @posts = Post.where(user_id: post_ids(@user)).includes(user: :profile).includes(:image_attachment).order(created_at: :desc)
      @friends = @user.friends.includes(:profile)
    elsif @user.friend_with?(current_user)
      @posts = Post.where(user_id: @user.id).includes(user: :profile).includes(:image_attachment).order(created_at: :desc)
    else
      redirect_to root_path, notice: "You may only view page's of friends."
    end
  end

  private

  def post_ids(user) 
    user.friends.pluck(:id) << user.id
  end
end

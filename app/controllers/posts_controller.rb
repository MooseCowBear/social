class PostsController < ApplicationController
  before_action :set_post, only [:edit, :update, :destroy]
  before_action :confirm_ownership, only [:edit, :update, :destroy]

  def index
    @posts = current_user.posts
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to root_path, status: :see_other
  end

  private 

  def set_post
    @post = Post.find(params[:id])
  end

  def confirm_ownership
    unless @post.user == current_user
      flash[:alert] = "Only the creators of a post may modify it."
      redirect_to root_path
    end
  end

  def post_params
    params.require(:post).permit(:user_id, :title, :body, :image)
  end
end

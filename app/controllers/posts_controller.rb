class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :confirm_ownership, only: [:edit, :update, :destroy]

  def index
    @posts = current_user.posts.includes([:image_attachment]).order(created_at: :desc)
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
      respond_to do |format|
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Post was successfully created." }
      end
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
      respond_to do |format|
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Post was successfully updated." } 
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Post was successfully deleted." } 
      format.turbo_stream { flash.now[:notice] = "Post was successfully deleted." } 
    end
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

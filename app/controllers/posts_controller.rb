class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy, :show]
  before_action :confirm_friendship, only: [:show]

  before_action only: [:edit, :update, :destroy] do
    confirm_ownership(@post, "Only the creators of a post may modify it.")
  end

  def index
    @posts = Post.find_posts_with_counts(current_user.id)
  end

  def show
    #knowing we will display 2 levels of comments, we can eager load
    @comments = @post.comments.includes(user: [:profile], comments: { user: [:profile] })
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

    updated_params = modify_params_for_image_removal(post_params)
    puts "updated PARAMS ARE:"
    pp updated_params

    #now testing if can actually remove image by setting to nil
    # PROBLEM, @post now has no image. so form rejects without body AND doesn't show image thumbnail anymore
    # one, not great option: to only add remove checkbox in form if there is a body. 
    # not ideal, but would allow user's to remove an image from a post that had a body too.
    if @post.update(updated_params.except(:remove_image))
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

  def confirm_friendship
    unless @post.user.friend_with?(current_user) || @post.user == current_user
      flash[:alert] = "You may only view friends' posts."
      redirect_to root_path
    end
  end

  def post_params
    params.require(:post).permit(:user_id, :title, :body, :image, :remove_image)
  end

  #move to concern, to be shared with profile
  def modify_params_for_image_removal(strong_params)
    if strong_params[:remove_image] == "1" && !strong_params[:image]
      return strong_params.merge(:image => nil)
    end
    strong_params
  end
end

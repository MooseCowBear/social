class LikesController < ApplicationController
  before_action :set_post

  def create
    #duplicate likes (ie. same user, same post) are prevented 
    #with model validations

    @like = @post.likes.new(user_id: current_user.id)

    respond_to do |format|
      if @like.save
        format.html { redirect_to post_path(@post), flash[:notice] = "Post has been liked." }
        format.turbo_stream { flash.now[:notice] = "Post has been liked." }
      else
        format.html { redirect_to post_path(@post), flash[:alert] = "Like could not be saved." }
      end
    end
  end

  def destroy
    @like = @post.likes.find(params[:id])
    @like.destroy

    respond_to do |format|
      format.html { redirect_to post_path(@post), flash[:notice] = "Post has been unliked." }
      format.turbo_stream { flash.now[:notice] = "Post has been unliked." }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end

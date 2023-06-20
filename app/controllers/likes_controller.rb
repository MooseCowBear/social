class LikesController < ApplicationController
  before_action :set_post

  def create
    @like = @post.likes.new(user_id: current_user.id)

      if @like.save
        respond_to do |format|
          format.html { redirect_to post_path(@post), notice: "Post has been liked." }
          format.turbo_stream { flash.now[:notice] = "Post has been liked." }
        end
      else
        flash[:alert] = "Like could not be saved." 
        redirect_to post_path(@post)
      end
 
  end

  def destroy
    @like = @post.likes.find(params[:id])
    @like.destroy

    respond_to do |format|
      format.html { redirect_to post_path(@post), notice: "Post has been unliked." }
      format.turbo_stream { flash.now[:notice] = "Post has been unliked." }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end

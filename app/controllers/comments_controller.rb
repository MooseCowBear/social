class CommentsController < ApplicationController
  include ActionView::RecordIdentifier
  include CommentsHelper

  before_action :set_commentable

  def new
    @comment = Comment.new
    @post = Post.find(params[:parent_post_id])
  end

  def create
    @comment =  @commentable.comments.new(comment_params)
    @comment.user = current_user
    @post = Post.find(@comment.parent_post_id)

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @post, notice: "Comment was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Comment was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @post = Post.find(@comment.parent_post_id)
  end

  def update
    @comment = Comment.find(params[:id])
    @post = Post.find(@comment.parent_post_id)

    if @comment.update(comment_params)
      respond_to do |format|
        format.html { redirect_to @post, notice: "Comment was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Comment was successfully updated." } 
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = Post.find(@comment.parent_post_id)
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @post, notice: "Comment was successfully deleted." }
      format.turbo_stream { flash.now[:notice] = "Comment was successfully deleted." }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_post_id)
  end

  def set_commentable
    if params[:comment_id]
      @commentable = Comment.find_by(id: params[:comment_id]) 
    elsif params[:post_id]
      @commentable = Post.find_by(id: params[:post_id].to_i)
    end
  end
end

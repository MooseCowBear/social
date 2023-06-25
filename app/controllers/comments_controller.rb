class CommentsController < ApplicationController
  include ActionView::RecordIdentifier
  include CommentsHelper

  before_action :set_commentable
  before_action :set_comment, only: [:edit, :update, :destroy]

  before_action only: [:edit, :update, :destroy] do
    confirm_ownership(@comment, "Only the creator of a comment may modify it.")
  end

  def new
    @comment = Comment.new
    @post = Post.find(params[:parent_post_id])
  end

  def create
    @comment =  @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.level = get_level
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
    @post = Post.find(@comment.parent_post_id)
  end

  def update
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

  def set_comment 
    @comment = Comment.find(params[:id])
  end

  def get_level
    #post comments have level one
    if params[:comment_id]
      @commentable.level + 1
    else
      1
    end
  end
end

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
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable, notice: "Comment was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Comment was successfully created." }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(dom_id_for_records(@commentable, @comment), partial: "comments/form", locals: { comment: @comment, commentable: @commentable })
        }
        format.html { render :new, status: :unprocessable_entity }
      end
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
        #did not replace flash...
        redirect_to post_path(@post), notice: "Comment was successfully updated." 
        format.turbo_stream { flash.now[:notice] = "Comment was successfully updated." } #this does not work...
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @commentable, notice: "Comment was successfully deleted." }
      format.turbo_stream { flash.now[:notice] = "Comment was successfully deleted." }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_post_id)
  end

  def set_commentable
    if params[:comment_id]
      @commentable = Comment.find_by_id(params[:comment_id]) 
    elsif params[:post_id]
      @commentable = Post.find_by_id(params[:post_id])
    end
  end
end

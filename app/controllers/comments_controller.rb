class CommentsController < ApplicationController
  include ActionView::RecordIdentifier

  include CommentsHelper
  before_action :set_commentable

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    #@post = Post.new(post_params)

    #if @post.save
      #respond_to do |format|
        #format.html { redirect_to @post, notice: "Post was successfully created." }
        #format.turbo_stream
      #end
    #else
      #render :new, status: :unprocessable_entity
    #end
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable, notice: "Post was successfully created." }
        format.turbo_stream
        #comment = Comment.new
        #format.turbo_stream {
          #render turbo_stream: turbo_stream.replace(dom_id_for_records(@commentable, comment), partial: "comments/form", locals: { comment: comment, commentable: @commentable })
        #}
        #format.html { redirect_to @commentable, notice: "Comment was successfully created." }
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
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      redirect_to @commentable
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    if params[:comment_id]
      @commentable = Comment.find_by_id(params[:comment_id]) 
    elsif params[:post_id]
      @commentable = Post.find_by_id(params[:post_id])
    end
  end
end

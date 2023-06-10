class CommentsController < ApplicationController
  include ActionView::RecordIdentifier
  include CommentsHelper

  before_action :set_commentable

  def new
    @comment = Comment.new
    @post = Post.find(params[:parent_post_id])
  end

  def create
    puts "my commentable is:"
    pp @commentable
    @comment =  @commentable.comments.new(comment_params)
    @comment.user = current_user
    puts "the comment looks like"
    pp @comment
  
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable, notice: "Comment was successfully created." }
        format.turbo_stream
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
      redirect_to post_path(@post) #could this be commentable if there was a turbo frame?
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @commentable, notice: "Comment was successfully deleted." }
      format.turbo_stream
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_post_id)
  end

  def set_commentable
    if params[:comment_id]
      puts "i had a comment id"
      @commentable = Comment.find_by_id(params[:comment_id]) 
    elsif params[:post_id]
      puts "i had a post id"
      @commentable = Post.find_by_id(params[:post_id])
    end
  end
end

class Comment < ApplicationRecord
  include Notifiable

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :notifications, as: :item, dependent: :destroy

  validates_presence_of :body
  validates :body, length: { maximum: 500 } 
  validates :level, numericality: { less_than: 3 }

  default_scope { order(created_at: :desc) } 

  def ancestor_post
    Post.find_by(id: parent_post_id)
  end

  def recipients
    #notify the author of a post that there is a new comment
    #and if that comment is a reply to another comment, notify
    #that comment's author too. 
    res = []
    post_author = Post.find_by(id: parent_post_id).user

    res << post_author unless post_author.id == user_id

    if commentable_type == "Comment"
      comment_user = Comment.find_by(id: commentable_id).user
      res << comment_user unless comment_user.id == user_id
    end
    res.uniq
  end 
end

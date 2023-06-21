class Comment < ApplicationRecord
  include Notifiable

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :notifications, as: :item, dependent: :destroy

  validates_presence_of :body
  validates :body, length: { maximum: 500 } 

  def ancestor_post
    Post.find_by(id: parent_post_id)
  end

  def recipients
    #notify the author of a post that there is a new comment
    #and if that comment is a reply to another comment, notify
    #that comment's author too. 
    post_author_id = Post.find_by(id: parent_post_id).user.id
    res = [post_author_id]
    if commentable_type == "Comment"
      res << Comment.find_by(id: commentable_id).user.id
    end
    res.uniq
  end
end

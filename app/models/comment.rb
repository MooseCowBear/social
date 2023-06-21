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
    [Post.find_by(id: parent_post_id).user.id]
  end
end

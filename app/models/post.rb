class Post < ApplicationRecord
  include Notifiable
  include Attachable  

  belongs_to :user
  has_one_attached :image

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :descendants, class_name: "Comment", foreign_key: "parent_post_id"

  has_many :likes, dependent: :destroy
  has_many :notifications, as: :item, dependent: :destroy

  validates_presence_of :title

  validate :acceptable_image
  validate :has_content

  default_scope { order(created_at: :desc) } 

  #trying to broadcast in realtime a friend's posts 
  after_create_commit do 
    self.recipients&.each do |r| 
      broadcast_prepend_to "broadcast_to_user_#{r.id}", 
      target: :posts,
      partial: "posts/post",
      locals: { post: self, curr: r } 
    end
  end

  after_update_commit do 
    self.recipients&.each do |r|
      broadcast_replace_to "broadcast_to_user_#{r.id}",
      target: self,
      partial: "posts/post",
      locals: { post: self, curr: r } 
    end
  end

  after_destroy_commit do 
    self.recipients&.each do |r|
      broadcast_remove_to "broadcast_to_user_#{r.id}",
      target: self
    end
  end

  def self.find_posts_with_counts(user_ids) 
    Post.where(user_id: user_ids).
      includes({ user: [:profile] }).
      with_attached_image.
      left_joins(:likes).
      joins("LEFT JOIN comments ON posts.id = comments.parent_post_id").
      select("posts.*, COUNT(DISTINCT likes.id) AS like_count, COUNT(DISTINCT comments.id) AS comment_count").
      group("posts.id")
  end

  def recipients
    user.friends.includes(:profile, :likes)
  end

  private

  def has_content
    unless !self.body.blank? || self.image.attached?
      errors.add(:post, "must have content.")
    end
  end
end

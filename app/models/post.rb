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

  def resized_image
    image.variant(resize_to_limit: [300, 300]).processed
  end

  def comment_count
    descendants.count
  end

  def likes_count #is this nec?
    likes.count
  end

  def user_like(user)
    likes.find_by(user_id: user.id)
  end

  def recipients
    user.friends.ids
  end

  private

  def has_content
    unless !self.body.blank? || self.image.attached?
      errors.add(:post, "must have content.")
    end
  end
end

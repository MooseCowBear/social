class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :descendants, class_name: "Comment", foreign_key: "parent_post_id"

  validates_presence_of :title

  validate :acceptable_image
  validate :has_content

  def resized_image
    image.variant(resize_to_limit: [300, 300]).processed
  end

  private

  def acceptable_image
    return unless image.attached?
  
    unless image.blob.byte_size <= 1.megabyte
      errors.add(:image, "is too big")
    end
  
    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG or PNG")
    end
  end

  def has_content
    unless !self.body.blank? || self.image.attached?
      errors.add(:post, "must have content.")
    end
  end
end

class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :title
  validates_presence_of :body

  validate :acceptable_image

  def resized_image
    image.variant(resize_to_limit: [300, 300]).processed
  end

  private

  def acceptable_image
    return unless image.attached?
  
    unless avatar.blob.byte_size <= 1.megabyte
      errors.add(:image, "is too big")
    end
  
    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(avatar.content_type)
      errors.add(:image, "must be a JPEG or PNG")
    end
  end
end

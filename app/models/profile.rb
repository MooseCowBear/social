class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validate :acceptable_image

  #for "friend requests, posts, etc."
  def avatar_as_thumnail
    avatar.variant(resize_to_limit: [50, 50]).processed
  end 

  #for profile show page
  def small_avatar
    avatar.variant(resize_to_limit: [150, 150]).processed
  end

  private

  def acceptable_image
    return unless avatar.attached?
  
    unless avatar.blob.byte_size <= 1.megabyte
      errors.add(:avatar, "is too big")
    end
  
    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(avatar.content_type)
      errors.add(:avatar, "must be a JPEG or PNG")
    end
  end
end

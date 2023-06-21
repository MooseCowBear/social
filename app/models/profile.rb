class Profile < ApplicationRecord
  include Attachable

  belongs_to :user
  has_one_attached :image

  validates :username, uniqueness: { case_sensitive: false }, length: { maximum: 20 }
  validate :acceptable_image

  #for "friend requests, posts, etc."
  def avatar_as_thumnail
    image.variant(resize_to_limit: [50, 50]).processed
  end 

  #for profile show page
  def small_avatar
    image.variant(resize_to_limit: [150, 150]).processed
  end
end

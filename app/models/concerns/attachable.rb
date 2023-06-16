module Attachable
  extend ActiveSupport::Concern

  def acceptable_image
    return unless self.image.attached?

    unless self.image.blob.byte_size <= 1.megabyte
      errors.add(:image, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG or PNG")
    end
  end
end
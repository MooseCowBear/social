class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates_presence_of :title
  validates_presence_of :body
end

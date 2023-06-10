class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :post

  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :body
  validates :body, length: { maximum: 500 } #does this seem reasonable?
end

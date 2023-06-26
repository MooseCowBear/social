class Like < ApplicationRecord
  include Notifiable

  belongs_to :user
  belongs_to :post

  has_many :notifications, as: :item, dependent: :destroy

  validates_uniqueness_of :user_id, scope: [:post_id]

  def recipients
    res = [] 
    res << post.user unless user_id == post.user_id
    res
  end
end

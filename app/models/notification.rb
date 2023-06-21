class Notification < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :user #the receiver of the notification

  scope :unread, ->{ where(read: false) }
  default_scope { order(created_at: :desc) } 

  after_create_commit do 
    broadcast_prepend_to "broadcast_to_user_#{self.user_id}", 
      target: :notifications
  end
  
  after_update_commit do 
    broadcast_replace_to "broadcast_to_user_#{self.user_id}", 
      target: self
  end
  
  after_destroy_commit do 
    broadcast_remove_to "broadcast_to_user_#{self.user_id}", 
      target: :notifications
  end
  
  after_commit do
    broadcast_update_to "broadcast_to_user_#{self.user_id}", 
      target: "notification_count", 
      partial: "notifications/count", 
      locals: { count: self.user.notification_count }
  end
end

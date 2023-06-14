module Notifiable
  extend ActiveSupport::Concern

  included do 
    after_create_commit :send_notifications
  end

  def send_notifications
    if self.respond_to?(:recipients)
      self.recipients&.each do |r|
        puts "creating a notification for user with id #{r}"
        Notification.create(user_id: r, item: self)
      end
    end
  end
end
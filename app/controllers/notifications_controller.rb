class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.unread.
      includes(item: [{ user: [:profile] }, :post]) 
    @notifications.update(read: true)
  end
end

class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.includes(item: [:user, :post]) #add back in unread
    @notifications.update(read: true)
  end
end
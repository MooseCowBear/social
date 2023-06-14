class FriendRequestsController < ApplicationController
  def index
    @friends = current_user.friends.includes(:profile)
    @pending = current_user.pending_friends.includes(:profile)
    @requested = current_user.requested_friends.includes(:profile)
    @declined = current_user.declined_friends
  end

  def create
    friend = User.find(params[:friend])
    response = FriendRequest.send_request(current_user, friend)
    if response
      flash[:notice] = "Your request has been sent."
    else 
      flash[:notice] = "Your request could not be sent."
    end
    redirect_to friend_requests_path 
  end

  def accept
    sender = User.find(params[:friend])
    FriendRequest.accept_request(sender, current_user)
    redirect_to friend_requests_path
  end

  def decline
    sender = User.find(params[:friend])
    FriendRequest.decline_request(sender, current_user)
    redirect_to friend_requests_path
  end

  def unfriend
    FriendRequest.unfriend(current_user.id, params[:friend])
    redirect_to friend_requests_path
  end
end

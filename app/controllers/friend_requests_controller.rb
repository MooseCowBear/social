class FriendRequestsController < ApplicationController
  def create
    @friend_request = FriendRequest.new(user_id: params[:user_id], friend_id: params[:friend_id])

    if @friend_request.save
      flash[:notice] = "Your friend request has been sent."
    else
      flash[:alert] = "Something went wrong."
    end
    redirect_to users_path
  end

  def update
    @friend_request = FriendRequest.find(params[:id])
    @friend_request.update(status: params[:status])
    redirect_to root_path
  end

  def destroy
  end
end

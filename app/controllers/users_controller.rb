class UsersController < ApplicationController
  def index
    @users = User.all_except(current_user).includes([:profile])
  end

  def show
    @user = User.find(params[:id])
  end
end

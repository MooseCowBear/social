class ProfilesController < ApplicationController
  before_action :require_permission, except: :show

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def destroy
  end

  private 

  def require_permission
    if current_user != Profile.find(params[:id]).user
      redirect_to root_path
    end
  end
end

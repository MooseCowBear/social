class ProfilesController < ApplicationController
  before_action :require_permission, except: :show

  def show
    @profile = Profile.find(params[:id])
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      redirect_to @profile
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update 
    @profile = Profile.find(params[:id])
    if @profile.update(profile_params)
      redirect_to @profile
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy
  
    redirect_to root_path, status: :see_other
  end

  private 

  def require_permission
    if current_user != Profile.find(params[:id]).user
      redirect_to root_path
    end
  end

  def profile_params
    require(:profile).permit(:username, :location, :birthday, :time_zone)
  end
end

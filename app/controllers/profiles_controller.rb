class ProfilesController < ApplicationController
  include RemoveImage
  
  before_action :set_profile, except: [:create, :new]

  before_action only: [:edit, :update, :destroy] do
    confirm_ownership(@profile, "Only profile owners may edit profiles.")
  end

  def show
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user

    if @profile.save
      flash[:notice] = "Profile has been created."
      redirect_to user_profile_path(@profile.user, @profile)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update 
    updated_params = modify_params_for_image_removal(profile_params)

    if @profile.update(updated_params.except(:remove_image))
      flash[:notice] = "Profile has been updated."
      redirect_to user_profile_path(@profile.user, @profile)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @profile.destroy
  
    redirect_to root_path, status: :see_other
  end

  private 

  def profile_params
    params.require(:profile).
      permit(:username, :location, :birthday, :time_zone, :user_id, :image, :interests, :remove_image)
  end

  def set_profile 
    @profile = Profile.find(params[:id])
  end

  def check_ownership
    if @profile.user != current_user
      flash[:notice] = "Only profile owners may edit profiles."
      redirect_to root_path
    end
  end
end

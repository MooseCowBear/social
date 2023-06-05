class HomeController < ApplicationController
  def index
    if current_user
      render :index #this will change, will want to redirect to user's page. then can delete the view
    else
      redirect_to new_user_session_path
    end
  end
end

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def confirm_ownership(elem, message)
    if elem.user != current_user
      flash[:alert] = message
      redirect_to root_path
    end
  end
end

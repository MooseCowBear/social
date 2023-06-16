class ErrorsController < ApplicationController
  def not_found
    render status:404
  end

  def server_error
    render status: 500
  end

  def unprocessable_content
    render states: 422
  end
end

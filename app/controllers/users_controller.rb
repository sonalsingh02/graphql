class UsersController < ApplicationController
  def query
    #byebug
    result = Schema.execute params[:query]
    render json: result
  end
end

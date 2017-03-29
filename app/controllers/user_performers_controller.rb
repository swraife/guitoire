class UserPerformersController < ApplicationController
  authorize_resource class: false

  def index
    @user = User.find(params[:user_id])
    @performers = @user.performers
  end
end

class CurrentPerformersController < ApplicationController
  def create
    session[:performer_id] = current_user.performers.find(params[:performer_id]).id
    redirect_back(fallback_location: '/')
  end
end
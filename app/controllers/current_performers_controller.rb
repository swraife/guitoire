class CurrentPerformersController < ApplicationController
  def create
    session[:performer_id] = current_user.performers.find(params[:performer_id]).id
    if request.referrer.include? "performers/#{current_performer.id}"
      redirect_to request.referrer.gsub(current_performer.id.to_s, params[:performer_id])
    else
      redirect_back(fallback_location: '/')
    end
  end
end
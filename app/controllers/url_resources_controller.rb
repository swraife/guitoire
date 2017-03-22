class UrlResourcesController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      url_resource = UrlResource.create!(url_resource_params)
      @song = current_performer.admin_songs.find(params[:song_id])
      url_resource.resources.create(target: @song, creator: current_performer)
    end
    redirect_to performer_song_path(current_performer, params[:song_id])
  rescue ActiveRecord::ActiveRecordError => exception
    redirect_to performer_song_path(current_performer, params[:song_id]),
      flash: { error: "Uh oh, something broke - #{exception}" }
  end

  private

  def url_resource_params
    params.require(:url_resource).permit(:url)
  end
end
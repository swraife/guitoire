class UrlResourcesController < ApplicationController
  def create
    url_resource = UrlResource.new(url_resource_params)
    @creator = SongResourceCreator.new(song_id: params[:song_id],
                               resourceable: url_resource)
    @creator.create
    if !@creator.errors
      redirect_to user_song_path(current_user, params[:song_id])
    else
      redirect_to user_song_path(current_user, params[:song_id]),
        flash: { error: "Uh oh, something broke - #{@creator.errors}" }
    end
  end

  private

  def url_resource_params
    params.require(:url_resource).permit(:url)
  end
end
class SongResourcesController < ApplicationController
  def destroy
    @song_resource = SongResource.find(params[:id])
    @song = @song_resource.song
    user_may_edit @song
    if @song_resource.destroy
      redirect_to :back
    end
  end
end

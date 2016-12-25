class FileResourcesController < ApplicationController
  def create
    file_resource = FileResource.new(file_resource_params)
    @creator = SongResourceCreator.new(song_id: params[:song_id],
                               resourceable: file_resource)
    @creator.create
    if !@creator.errors
      redirect_to user_song_path(current_user, params[:song_id])
    else
      redirect_to user_song_path(current_user, params[:song_id]),
        flash: { error: "Uh oh, something broke - #{@creator.errors}" }
    end
  end

  private

  def file_resource_params
    params.require(:file_resource).permit(:main)
  end
end

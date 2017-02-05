class FileResourcesController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      file_resource = FileResource.create!(file_resource_params)
      @song = current_user.admin_songs.find(params[:song_id])
      file_resource.resources.create(target: @song, creator: current_user)
    end
    redirect_to user_song_path(current_user, params[:song_id])
  rescue ActiveRecord::ActiveRecordError => exception
    redirect_to user_song_path(current_user, params[:song_id]),
      flash: { error: "Uh oh, something broke - #{exception}" }
  end

  private

  def file_resource_params
    params.require(:file_resource).permit(:main)
  end
end

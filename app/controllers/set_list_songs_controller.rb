class SetListSongsController < ApplicationController
  def create
    @set_list_song = SetListSong.create(set_list_song_params)
  end

  def destroy
    @set_list_song = current_user.set_list_songs.find(params[:id])
    respond_to do |format|
      if @set_list_song.destroy
        format.js {}
      end
    end
  end

  private

  def set_list_song_params
    params.require(:set_list_song).permit(:routine_id, :song_id)
  end
end
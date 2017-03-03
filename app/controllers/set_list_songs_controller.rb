class SetListSongsController < ApplicationController
  def create
    @set_list_song = SetListSong.create(set_list_song_params)
  end

  private

  def set_list_song_params
    params.require(:set_list_song).permit(:routine_id, :song_id)
  end
end
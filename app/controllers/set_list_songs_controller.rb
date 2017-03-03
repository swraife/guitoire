class SetListSongsController < ApplicationController
  def create
    @set_list_song = SetListSong.create(set_list_song_params)
  end

  def update
    @set_list_song = SetListSong.find(params[:moved])
    prev_and_next_value
    if @next_value - @prev_value <= 1
      @set_list_song.refresh_sort_values!
      prev_and_next_value
    end
    @set_list_song.update(sort_value: (@prev_value + @next_value) / 2)
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

  def prev_and_next_value
    @prev ||= SetListSong.find(params[:prev]) if params[:prev]
    @next ||= SetListSong.find(params[:next]) if params[:next]
    @prev_value = @prev ? @prev.reload.sort_value : 0
    @next_value = @next ? @next.reload.sort_value : @prev_value + 1000
  end
end
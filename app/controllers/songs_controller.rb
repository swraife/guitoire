class SongsController < ApplicationController
  def show
    @song = Song.includes(:resources, :song_resources).find(params[:id])
  end

  def index
    @songs = current_user.songs.order(:name)
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.create(song_params.merge(user: current_user))
    redirect_to user_song_path(current_user, @song)
  end

  def destroy
  end

  def edit
    @song = current_user.songs.find(params[:id])
  end

  def update
    @song = current_user.songs.find(params[:id])
    @song.update(song_params)
    redirect_to user_song_path(current_user, @song)
  end

  private

  def song_params
    params.require(:song).permit(:name, :description, :tempo, :music_key, :composer_id, :scale, :time_signature, version_list: [], genre_list: [], generic_list: [])
  end
end

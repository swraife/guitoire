class SongsController < ApplicationController
  def show
    @song = Song.includes(:song_roles, resources: [:resourceable]).find(params[:id])
    @current_user_song_role = @song.song_roles.where(user: current_user).first_or_initialize
  end

  def index
    @user = User.find(params[:user_id])
    @songs = @user.songs.includes(:tags).order(:name)
  end

  def new
    @song = Song.new
  end

  def create
    if @song = Song.create(song_params.merge(creator: current_user))
      redirect_to user_song_path(current_user, @song)
    end
  end

  def destroy
    @song = current_user.created_songs.find(params[:id])
    if @song.destroy
      redirect_to user_songs_path(current_user)
    end
  end

  def edit
    @song = current_user.admin_songs.find(params[:id])
  end

  def update
    @song = current_user.admin_songs.find(params[:id])
    if @song.update(song_params)
      redirect_to user_song_path(current_user, @song)
    end
  end

  private

  def song_params
    params.require(:song).permit(:name, :description, :tempo, :music_key, :composer_id, :scale, :time_signature, version_list: [], genre_list: [], generic_list: [], composer_list: [])
  end
end

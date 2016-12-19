class SongsController < ApplicationController
  before_action :set_user

  def show
    @song = Song.find(params[:id])
  end

  def index
    @songs = @user.songs
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.create(song_params.merge(user: current_user))
  end

  def destroy
  end

  def edit
    @song = @current_user.songs.find(params[:id])
  end

  def update
    @song = @current_user.songs.find(params[:id])
    @song.update(song_params)
  end

  private

  def song_params
    params.require(:song).permit(:name, :description, :tempo, :music_key)
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end

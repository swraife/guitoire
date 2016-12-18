class SongsController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @song = Song.find(params[:id])
  end

  def index
  end

  def new
    @user = User.find(params[:user_id])
    @song = Song.new
  end

  def create
    @song = Song.create(song_params.merge(user: current_user))
  end

  def destroy
  end

  def edit
  end

  def update
  end

  private

  def song_params
    params.require(:song).permit(:name, :description, :tempo, :music_key)
  end
end

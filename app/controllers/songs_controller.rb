class SongsController < ApplicationController
  def show
    @song = Song.includes(:song_roles, resources: [:resourceable]).find(params[:id])
    @current_user_song_role = @song.song_roles.where(user: current_user).first_or_initialize
  end

  def index
    @user = User.find(params[:user_id])
    @songs = @user.subscriber_songs.includes(:tags).order(:name)
  end

  def new
    @song = Song.new
    @songs = current_user.songs.order(:name)
  end

  def create
    if params[:song_id]
      @song = Song.copiable.find(params[:song_id])
      if @new_song = SongCopier.new(copy_creator: current_user, song: @song).copy!
        redirect_to user_song_path(current_user, @new_song)
      end
    elsif @song = Song.create(song_params.merge(creator: current_user))
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
    @songs = current_user.songs.order(:name)
  end

  def update
    @song = current_user.admin_songs.find(params[:id])
    if @song.update(song_params.tap { |h| h.delete(:admin_users) })
      SongRoleUpdater.new(@song, song_params[:admin_user_ids]).update!
      redirect_to user_song_path(current_user, @song)
    end
  end

  private

  def song_params
    params.require(:song).permit(:name, :description, :tempo, :music_key, :composer_id, :scale, :time_signature, version_list: [], genre_list: [], generic_list: [], composer_list: [], admin_user_ids: [])
  end
end

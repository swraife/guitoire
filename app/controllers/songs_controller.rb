class SongsController < ApplicationController
  def show
    @song = Song.includes(resources: [:resourceable]).find(params[:id])
    @current_user_song_role = @song.song_roles.where(owner: current_user).first_or_initialize
  end

  def index
    @user = User.find(params[:user_id])
    order = SongRole.scopes.include?(params[:sort_by]&.to_sym) ? params[:sort_by] : 'order_by_song_name'
    @song_roles = @user.subscriber_song_roles.includes(:plays, song: :tags).send(order)

    respond_to do |format|
      format.js {}
      format.html {}
    end
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
    @song = Song.find(params[:id])
    redirect_to :back unless current_user.actors.include?(@song.owner)

    if @song.destroy
      redirect_to user_songs_path(current_user)
    end
  end

  def edit
    @song = Song.find(params[:id])
    redirect_to :back unless current_user.may_edit? @song
    @songs = Song.includes(:subscriber_song_roles)
                 .where(song_roles: { owner: current_user.actors })
                 .order(:name)
  end

  def update
    @song = Song.find(params[:id])
    redirect_to :back unless current_user.may_edit? @song

    # Have to use song_updater instead of ActiveRecord methods, because user
    # may have an existing non-admin song_role for the song
    if @song.update(song_params.except(:admin_user_ids, :admin_group_ids))
      SongRoleUpdater.new(@song, song_params[:admin_user_ids],
                          song_params[:admin_group_ids]).update!
      redirect_to user_song_path(current_user, @song)
    end
  end

  private

  def song_params
    params.require(:song).permit(
      :name, :description, :tempo, :music_key, :composer_id, :scale,
      :time_signature, :global_owner, version_list: [], genre_list: [],
      generic_list: [], composer_list: [], admin_user_ids: [],
      admin_group_ids: []
    )
  end
end

class SongsController < ApplicationController
  load_and_authorize_resource except: :new

  def index
    @user = User.find(params[:user_id])
    order = SongRole.scopes.include?(params[:sort_by]&.to_sym) ? params[:sort_by] : 'order_by_song_name'
    @song_roles = @user.subscriber_song_roles.includes(:plays, song: :tags).send(order)

    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def show
    @song = Song.includes(resources: [:resourceable]).find(params[:id])
    @current_user_song_role = @song.song_roles.where(owner: current_user)
                                              .first_or_initialize
  end

  def new
    @song = Song.new
    @songs = current_user.songs.order(:name)
  end

  def create
    if @song = Song.create(song_params.merge(creator: current_user))
      redirect_to @song
    end
  end

  def copy
    if @new_song = SongCopier.new(copy_creator: current_user, song: @song).copy!
      redirect_to song_path(@new_song),
        flash: { notice: "Copy of #{@new_song.name} created!" }
    end
  end

  def destroy
    if @song.destroy
      redirect_to user_songs_path(current_user),
        flash: { notice: "#{@song.name} was deleted!"}
    end
  end

  def edit
    @songs = Song.includes(:subscriber_song_roles)
                 .where(song_roles: { owner: current_user.actors })
                 .order(:name)
  end

  def update
    # Have to use song_role_updater instead of ActiveRecord methods, because user
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

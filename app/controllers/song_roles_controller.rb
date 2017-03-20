class SongRolesController < ApplicationController
  load_and_authorize_resource

  def create
    @song = Song.find(song_role_params[:song_id])
    if SongRole.create(song_role_params)
      redirect_to :back
    end
  end

  def update
    @song = @song_role.song
    if @song_role.update(song_role_params)
      redirect_to :back
    end
  end

  private

  def song_role_params
    params.require(:song_role).permit(:song_id, :role, :global_owner)
  end
end
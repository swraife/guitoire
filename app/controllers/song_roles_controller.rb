class SongRolesController < ApplicationController
  def create
    @song = Song.find(song_role_params[:song_id])
    redirect_to :back unless @song.permissible_roles.include?(song_role_params[:role])
    SongRole.create(song_role_params.merge(user: current_user))
  end

  def update
    @song_role = current_user.song_roles.find(params[:id])
    @song = @song_role.song
    redirect_to :back unless @song.permissible_roles.include?(song_role_params[:role])
    @song_role.update(song_role_params)
  end

  private

  def song_role_params
    params.require(:song_role).permit(:song_id, :role)
  end
end
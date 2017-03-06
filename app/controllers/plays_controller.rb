class PlaysController < ApplicationController
  def create
    @play = SongRole.where(song_id: play_params[:song_id], user: current_user)
                    .first_or_create.plays.create(user: current_user)
    respond_to do |format|
      format.js { flash.now[:notice] = @play.create_flash_notice }
    end
  end

  private

  def play_params
    params.require(:play).permit(:song_id)
  end
end

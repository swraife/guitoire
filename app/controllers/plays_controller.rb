class PlaysController < ApplicationController
  def create
    @song_role = SongRole.where(song_id: play_params[:song_id], owner: current_user)
                    .first_or_create
    @play = @song_role.plays.new(user: current_user)
    authorize! :create, @play, params

    if @play.save
      respond_to do |format|
        format.js { flash.now[:notice] = @play.create_flash_notice }
      end
    else
      # TODO: something!
    end
  end

  private

  def play_params
    params.require(:play).permit(:song_id)
  end
end

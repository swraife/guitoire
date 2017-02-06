class PlaysController < ApplicationController
  def create
    @play = current_user.plays.create(play_params)
    respond_to do |format|
      format.js { flash.now[:notice] = @play.create_flash_notice }
    end
  end

  private

  def play_params
    params.require(:play).permit(:song_id)
  end
end

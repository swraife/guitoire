class PlaysController < ApplicationController
  def create
    @feat_role = FeatRole.where(feat_id: play_params[:feat_id], owner: current_performer)
                    .first_or_create
    @play = @feat_role.plays.new(performer: current_performer)
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
    params.require(:play).permit(:feat_id)
  end
end

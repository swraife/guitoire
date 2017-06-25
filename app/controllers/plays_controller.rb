class PlaysController < ApplicationController
  def create
    @feat_role = FeatRole.where(feat_id: play_params[:feat_id],
                                owner: current_performer).first_or_create
    @play = @feat_role.plays.new(performer: current_performer,
                                 feat_id: play_params[:feat_id])
    authorize! :create, @play, params

    if @play.save
      respond_to do |format|
        format.js { flash.now[:play_create] = @play.create_flash_notice }
      end
    else
      # TODO: something!
    end
  end

  def destroy
    @play = Play.where(performer: current_user.performers).find(params[:id])
    if @play.destroy
      respond_to do |format|
        format.js { flash.now[:notice] = @play.destroy_flash_notice }
      end
    else
      respond_to do |format|
        format.js { flash.now[:error] = 'Uh oh, something broke!' }
      end
    end
  end

  private

  def play_params
    params.require(:play).permit(:feat_id)
  end
end

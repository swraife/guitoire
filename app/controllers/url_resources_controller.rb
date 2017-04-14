class UrlResourcesController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      url_resource = UrlResource.create!(url_resource_params)
      @feat = current_performer.admin_feats.find(params[:feat_id])
      url_resource.resources.create(target: @feat, creator: current_performer)
    end
    redirect_to performer_feat_path(current_performer, params[:feat_id])
  rescue ActiveRecord::ActiveRecordError => exception
    redirect_to performer_feat_path(current_performer, params[:feat_id]),
      flash: { error: "Uh oh, something broke - #{exception}" }
  end

  private

  def url_resource_params
    params.require(:url_resource).permit(:url)
  end
end
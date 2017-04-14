class FileResourcesController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      file_resource = FileResource.create!(file_resource_params)
      @feat = current_performer.admin_feats.find(params[:feat_id])
      file_resource.resources.create(target: @feat, creator: current_performer)
    end
    redirect_to performer_feat_path(current_performer, params[:feat_id])
  rescue ActiveRecord::ActiveRecordError => exception
    redirect_to performer_feat_path(current_performer, params[:feat_id]),
      flash: { error: "Uh oh, something broke - #{exception}" }
  end

  private

  def file_resource_params
    params.require(:file_resource).permit(:main)
  end
end

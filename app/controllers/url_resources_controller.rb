class UrlResourcesController < ApplicationController
  def create
    @target = GlobalID::Locator.locate resource_params[:global_target]
    authorize! :edit, @target

    ActiveRecord::Base.transaction do
      url_resource = UrlResource.create!(url_resource_params)
      url_resource.resources.create!(target: @target,
                                     creator: current_performer)
    end
    redirect_to polymorphic_path(@target.redirect_target)
  rescue ActiveRecord::ActiveRecordError => exception
    redirect_to polymorphic_path(@target.redirect_target),
      flash: { error: "Uh oh, something broke - #{exception}" }
  end

  private

  def url_resource_params
    params.require(:url_resource).permit(:url)
  end

  def resource_params
    params.require(:resource).permit(:name, :global_target)
  end
end

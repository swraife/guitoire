class FileResourcesController < ApplicationController
  def create
    @target = GlobalID::Locator.locate resource_params[:global_target]
    authorize! :edit, @target

    ActiveRecord::Base.transaction do
      file_resource = FileResource.create!(file_resource_params)
      file_resource.resources.create!(target: @target,
                                      name: resource_params[:name],
                                      creator: current_performer)
    end
    redirect_to polymorphic_path(@target.redirect_target)
  rescue ActiveRecord::ActiveRecordError => exception
    redirect_to polymorphic_path(@target.redirect_target),
      flash: { error: "Uh oh, something broke - #{exception}" }
  end

  private

  def file_resource_params
    params.require(:file_resource).permit(:main)
  end

  def resource_params
    params.require(:resource).permit(:name, :global_target)
  end
end

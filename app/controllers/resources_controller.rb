class ResourcesController < ApplicationController
  def destroy
    @resource = Resource.find(params[:id])
    @target = @resource.target
    user_may_edit @target
    if @resource.destroy
      redirect_to :back
    end
  end
end

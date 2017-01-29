class ResourcesController < ApplicationController
  def destroy
    @resource = Resource.find(params[:id])
    @owner = @resource.owner
    user_may_edit @owner
    if @resource.destroy
      redirect_to :back
    end
  end
end

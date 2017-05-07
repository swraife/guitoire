class ResourcesController < ApplicationController
  load_and_authorize_resource

  def destroy
    if @resource.destroy
      redirect_back(fallback_location: @resource.target)
    end
  end
end

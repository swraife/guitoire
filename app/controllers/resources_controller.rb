class ResourcesController < ApplicationController
  load_and_authorize_resource

  def destroy
    if @resource.destroy
      redirect_to :back
    end
  end
end

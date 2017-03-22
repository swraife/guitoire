class PerformersController < ApplicationController
  load_and_authorize_resource except: :index

  def index
    @performers = Performer.visible_to(current_performer).order(:public_name)
  end

  def show
    @friends = @performer.accepted_friends
    @friendship = current_performer.friendship_with(@performer)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
    if current_performer.update(performer_params)
      redirect_to current_performer
    end
  end

  def destroy
  end

  private

  def performer_params
    params.require(:performer).permit(
      :name, :public_name, :avatar, :description, :email, :visibility
    )
  end
end
class GroupsController < ApplicationController

  def show
    @group = current_user.groups.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    if @group = Group.create(group_params)
      redirect_to @group
    else
      redirect_to :back
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :avatar, :creator_id, settings: [])
  end
end
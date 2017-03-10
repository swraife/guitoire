class GroupsController < ApplicationController
  def show
    @group = current_user.groups.find(params[:id])
    @current_user_group_role = current_user.group_roles.where(user: current_user).first_or_initialize
  end

  def new
    @group = Group.new
  end

  def create
    if @group = Group.create(group_params.merge(creator: current_user))
      redirect_to @group
    else
      redirect_to :back
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :description, :avatar, :creator_id, settings: [], admin_user_ids: [])
  end
end
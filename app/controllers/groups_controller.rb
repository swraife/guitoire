class GroupsController < ApplicationController
  load_and_authorize_resource except: :new
  skip_load_resource :index

  def index
    @user = User.find(params[:user_id])
    @groups = @user.groups.includes(:users).visible_to(current_user)
                .order('lower(name)')
  end

  def show
    @current_user_group_role = current_user.group_roles.find_by(group: @group)

    @song_roles = @group.subscriber_song_roles.includes(:plays, song: :tags)
    @routines = @group.routines.order(:name)
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

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to @group
    else
      redirect_to :back
    end
  end

  def destroy
    if @group.destroy
      redirect_to user_groups_path(current_user)
    else
      redirect_to :back
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :description, :avatar, :creator_id,
      settings: [], admin_user_ids: [])
  end
end
class GroupsController < ApplicationController
  load_and_authorize_resource except: :new
  skip_load_resource :index

  def index
    @performer = Performer.find(params[:performer_id])
    @groups = @performer.groups.includes(:performers).visible_to(current_performer)
                .order('lower(name)')
  end

  def show
    @current_performer_group_role =
      current_performer.group_roles.where(group: @group).first_or_initialize

    @feats = Query::FeatQueryService.new(
      actors: [@group], viewer: current_performer
    ).find_feats

    @routines = @group.routines.visible_to(current_performer).order(:name)
  end

  def new
    @group = Group.new
    @followed = current_performer.followed
  end

  def create
    if @group = Group.create(group_params.merge(creator: current_performer))
      redirect_to @group
    else
      redirect_back fallback_location: root_path, flash: { error: 'Uh oh, something broke!' }
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      can?(:show, @group.reload) ? redirect_to(@group) : redirect_to('/')
    else
      redirect_back fallback_location: @group, flash: { error: 'Uh oh, something broke!' }
    end
  end

  def destroy
    if @group.destroy
      redirect_to performer_groups_path(current_performer)
    else
      redirect_back fallback_location: @group, flash: { error: 'Uh oh, something broke!' }
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :description, :avatar, :creator_id,
      :visibility, settings: [], admin_performer_ids: [])
  end
end
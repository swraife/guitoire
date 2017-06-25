class RoutinesController < ApplicationController
  load_and_authorize_resource except: :new
  skip_load_resource :index  # don't think this is working

  def index
    @performer = Performer.find(params[:performer_id])
    @routines = @performer.routines.visible_to current_performer
  end

  def show
    # Watch out: including :routine_roles breaks routine_feats ordering
    @routine = Routine.includes(:routine_feats, :feats)
                      .visible_to(current_performer)
                      .find(params[:id])
    @actors = current_performer.actors
    @feats = Query::FeatQueryService.new(actors: @actors,
                                         viewer: current_performer).find_feats
  end

  def new
    @routine = Routine.new
    @followed = current_performer.followed
  end

  def create
    if @routine.save
      redirect_to @routine
    else
      redirect_back fallback_location: root_path,
                    flash: { error: 'Uh oh, something broke!' }
    end
  end

  def edit
    @followed = current_performer.followed
  end

  def update
    if @routine.update(routine_params)
      redirect_to @routine
    else
      redirect_back fallback_location: @routine,
                    flash: { error: 'Uh oh, something broke!' }
    end      
  end

  private

  def routine_params
    params.require(:routine).permit(
      :name, :description, :global_owner, :visibility,
      performer_ids: [], group_ids: [], generic_list: [],
    )
  end
end

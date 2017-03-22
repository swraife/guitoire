class RoutinesController < ApplicationController
  load_and_authorize_resource except: :new
  skip_load_resource :index  # don't think this is working

  def index
    @performer = Performer.find(params[:performer_id])
    @routines = @performer.routines.visible_to current_performer
  end

  def show
    # Watch out: including :routine_roles breaks set_list_songs ordering
    @routine = Routine.includes(:set_list_songs, :songs).visible_to(current_performer)
                      .find(params[:id])
    @songs = @routine.owner.songs.order(:name)
  end

  def new
    @routine = Routine.new
  end

  def create
    if @routine.save
      redirect_to @routine
    else
      redirect_to :back, flash: { error: 'Uh oh, something broke!' }
    end
  end

  def edit
  end

  def update
    if @routine.update(routine_params)
      redirect_to @routine
    else
      redirect_to :back, flash: { error: 'Uh oh, something broke!' }
    end      
  end

  private

  def routine_params
    params.require(:routine).permit(
      :name, :description, :global_owner, :visibility,
      performer_ids: [], group_ids: []
    )
  end
end

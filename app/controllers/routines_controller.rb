class RoutinesController < ApplicationController
  def index
    @routines = current_user.routines
  end

  def show
    # Watch out: including :routine_roles breaks set_list_songs ordering
    @routine = Routine.includes(:set_list_songs, :songs).joins(:routine_roles)
                      .where(routine_roles: { owner: current_user.actors })
                      .find(params[:id])
    @songs = @routine.owner.songs.order(:name)
  end

  def new
    @routine = Routine.new
  end

  def create
    @routine = Routine.new(routine_params)

    redirect_to '/' and return unless current_user.actors.include?(@routine.owner)

    if @routine.save
      redirect_to @routine
    else
      redirect_to :back, flash: { error: 'Uh oh, something broke!' }
    end
  end

  def edit
    @routine = Routine.find(params[:id])

    redirect_to :back unless current_user.may_edit? @routine
  end

  def update
    @routine = Routine.find(params[:id])

    redirect_to :back unless current_user.may_edit? @routine
    if @routine.update(routine_params)
      redirect_to @routine
    else
      redirect_to :back, flash: { error: 'Uh oh, something broke!' }
    end      
  end

  private

  def routine_params
    params.require(:routine).permit(:name, :description, :global_owner)
  end
end

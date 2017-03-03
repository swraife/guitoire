class RoutinesController < ApplicationController
  def index
    @routines = current_user.routines
  end

  def show
    @routine = current_user.routines.includes(:set_list_songs, :songs).find(params[:id])
    @songs = current_user.songs
  end

  def new
    @routine = Routine.new
  end

  def create
    @routine = current_user.routines_as_owner.new(routine_params)

    if @routine.save
      redirect_to @routine
    else
      redirect_to :back, flash: { error: 'Uh oh, something broke!' }
    end
  end

  def update
    @moved = SetListSong.find(params[:moved]) if params[:moved]
    @prev_value = params[:prev] ? SetListSong.find(params[:prev]).sort_value : 0
    @next_value = params[:next] ? SetListSong.find(params[:next]).sort_value : @prev_value + 1000
    @moved.update(sort_value: (@prev_value + @next_value) / 2)
  end

  private

  def routine_params
    params.require(:routine).permit(:name, :description)
  end
end

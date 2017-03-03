class RoutinesController < ApplicationController
  def new
    @routine = Routine.new
  end

  def create
    @routine = Routine.create(routine_params)
  end

  private

  def routine_params
    params.require(:routine).permit(:name, :description)
  end
end

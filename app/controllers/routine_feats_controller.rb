class RoutineFeatsController < ApplicationController
  load_and_authorize_resource

  def create
    @routine_feat = RoutineFeat.create(routine_feat_params)
  end

  def update
    prev_and_next_value
    if @next_value - @prev_value <= 1
      @routine_feat.refresh_sort_values!
      prev_and_next_value
    end
    @routine_feat.update(sort_value: (@prev_value + @next_value) / 2)
  end

  def destroy
    respond_to do |format|
      if @routine_feat.destroy
        format.js {}
      end
    end
  end

  private

  def routine_feat_params
    params.require(:routine_feat).permit(:routine_id, :feat_id)
  end

  def prev_and_next_value
    @prev ||= RoutineFeat.find(params[:prev]) if params[:prev]
    @next ||= RoutineFeat.find(params[:next]) if params[:next]
    @prev_value = @prev ? @prev.reload.sort_value : 0
    @next_value = @next ? @next.reload.sort_value : @prev_value + 1000
  end
end
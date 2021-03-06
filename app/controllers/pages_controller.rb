class PagesController < ApplicationController
  def index
    @activities = Query::ActivityService.new(current_performer)
                    .dashboard_activities
                    .order(created_at: :desc).page(params[:page]).per(35)
    @activity_grouper = ActivityGrouper.new(@activities)
  end
end

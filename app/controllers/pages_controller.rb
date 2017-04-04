class PagesController < ApplicationController
  def index
    @activities = PublicActivity::Activity
                    .activities_with_associations_preloaded
                    .order(created_at: :desc).page(params[:page])
    @activity_grouper = ActivityGrouper.new(@activities)
  end
end

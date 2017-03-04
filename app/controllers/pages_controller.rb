class PagesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.includes(:trackable, :recipient, :owner).order(created_at: :desc).page(1)
    @activity_grouper = ActivityGrouper.new(@activities)
  end
end

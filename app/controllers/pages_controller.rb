class PagesController < ApplicationController
  def index
    @activities = PublicActivity::Activity
                    .includes(:trackable, :owner, recipient: :creator)
                    .order(created_at: :desc).page(1)
    @activity_grouper = ActivityGrouper.new(@activities)
  end
end

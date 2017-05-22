class FollowsController < ApplicationController
  def create
    @follow = Follow.new(follow_params.merge(follower: current_performer))

    if @follow.save!
      respond_to do |format|
        format.js { flash.now[:notice] = 'Followed!' }
      end
    end    
  end

  def destroy
    @follow = current_performer.follows_as_follower.find(params[:id])

    if @follow.destroy!
      respond_to do |format|
        format.js { flash.now[:notice] = 'Unfollowed!' }
      end
    end
  end

  private

  def follow_params
    params.require(:follow).permit(:performer_id)
  end
end
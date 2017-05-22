#TODO: Refactor to make restful.
class FollowersController < ApplicationController

  def create
    @follower = Follower.new(follower_params.merge(connector: current_performer))

    if @follower.request! current_performer
      respond_to do |format|
        format.js { flash.now[:notice] = "Follower #{@follower.status}!"}
      end
    end    
  end

  def update
    @follower = current_performer.followers.find(params[:id])

    if @follower.request! current_performer
      respond_to do |format|
        format.js { flash.now[:notice] = "Follower #{@follower.status}!"}
      end
    end
  end

  def destroy
    @follower = current_performer.followers.find(params[:id])

    if @follower.decline!
      respond_to do |format|
        format.js { flash.now[:notice] = 'Follower declined!' }
      end
    end
  end

  private

  def follower_params
    params.require(:follower).permit(:connected_id)
  end

  def performer_ids
    [current_performer.id, follower_params[:connected_id]]
  end
end
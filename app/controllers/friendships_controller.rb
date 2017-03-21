#TODO: Refactor to make restful.
class FriendshipsController < ApplicationController

  def create
    @friendship = Friendship.new(friendship_params.merge(connector: current_user))

    if @friendship.request! current_user
      respond_to do |format|
        format.js { flash.now[:notice] = "Friendship #{@friendship.status}!"}
      end
    end    
  end

  def update
    @friendship = current_user.friendships.find(params[:id])

    if @friendship.request! current_user
      respond_to do |format|
        format.js { flash.now[:notice] = "Friendship #{@friendship.status}!"}
      end
    end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])

    if @friendship.decline!
      respond_to do |format|
        format.js { flash.now[:notice] = 'Friendship declined!' }
      end
    end
  end

  private

  def friendship_params
    params.require(:friendship).permit(:connected_id)
  end

  def user_ids
    [current_user.id, friendship_params[:connected_id]]
  end
end
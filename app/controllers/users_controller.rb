class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.visible_to(current_user).order(:first_name)
  end

  def show
    @friends = @user.accepted_friends
    @friendship = current_user.friendship_with(@user)
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to user_songs_path(current_user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name,
                                 :avatar, :email, :visibility)
  end
end
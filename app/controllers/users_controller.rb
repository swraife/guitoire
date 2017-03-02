class UsersController < ApplicationController
  def index
    @users = User.all.order(:first_name)
  end

  def edit
    @user = current_user
  end

  def update
    current_user.update(user_params)
    redirect_to :root
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :avatar, :email)
  end
end
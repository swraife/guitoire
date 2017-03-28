class UsersController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to '/', flash: { notice: 'Profile Updated!' }
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name,
                                 :avatar, :email, :visibility)
  end
end

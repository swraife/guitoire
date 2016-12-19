class SetListsController < ApplicationController
  def new
    @set_list = SetList.new
  end

  def create
    @set_list = SetList.create(set_list_params)
    @set_list.users << current_user
    redirect_to 'root'
  end

  private

  def set_list_params
    params.require(:set_list).permit(:name, :description)
  end
end

class SetListsController < ApplicationController
  def new
    @set_list = SetList.new
  end
end

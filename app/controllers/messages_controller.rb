class MessagesController < ApplicationController
  def index
    @messages = current_user.message_copies
  end

  def new
  end

  def create
    current_user.messages.create(message_params)
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
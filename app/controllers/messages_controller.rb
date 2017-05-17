class MessagesController < ApplicationController
  def create
    @message = current_performer.messages.create(message_params)
  end

  private

  def message_params
    params.require(:message).permit(:content, :message_thread_id)
  end
end
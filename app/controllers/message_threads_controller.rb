class MessageThreadsController < ApplicationController
  before_action :add_current_user_to_user_ids, only: [:create]

  def index
    @message_threads = current_user.message_threads
  end

  def create
    @message_thread = MessageThread.new(message_thread_params)
    @message = @message_thread.messages.build(message_params.merge(user_id: current_user.id))
    @message_thread.save
  end

  private

  def message_thread_params
    params.require(:message_thread).permit(:name, user_ids: [])
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def add_current_user_to_user_ids
    params[:message_thread][:user_ids].push(current_user.id)
  end
end
class MessageThreadsController < ApplicationController
  before_action :add_current_performer_to_performer_ids, only: [:create]
  after_action :view_message_copies

  def index
    @message_threads = current_performer.message_threads.includes(:messages, :performers, :message_copies).order(updated_at: :desc)
    @followed = current_performer.followed
  end

  def create
    @message_thread = MessageThread.new(message_thread_params)
    @message = @message_thread.messages.build(message_params.merge(performer_id: current_performer.id))
    @message_thread.save
  end

  private

  def message_thread_params
    params.require(:message_thread).permit(:name, performer_ids: [])
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def add_current_performer_to_performer_ids
    params[:message_thread][:performer_ids].push(current_performer.id)
  end

  def view_message_copies
    current_performer.message_copies.each do |message_copy|
      message_copy.viewed!
    end
  end
end
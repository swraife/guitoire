# == Schema Information
#
# Table name: messages
#
#  id                :integer          not null, primary key
#  performer_id      :integer
#  message_thread_id :integer
#  content           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Message < ApplicationRecord
  belongs_to :message_thread, touch: true
  belongs_to :performer

  has_many :message_copies, dependent: :destroy

  after_create :create_message_copies

  private

  def create_message_copies
    send_emails = message_thread.messages.last(2).first.created_at < 30.minutes.ago
    message_thread.performers.each do |thread_performer|
      status = performer == thread_performer ? 1 : 0
      MessageCopy.create(performer: thread_performer, message: self, status: status)

      next if performer == thread_performer || !send_emails
      # UserMailer.new_message_alert(thread_performer, self).deliver_now
    end
  end
end

# == Schema Information
#
# Table name: messages
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  message_thread_id :integer
#  content           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Message < ApplicationRecord
  belongs_to :message_thread, touch: true
  belongs_to :user

  has_many :message_copies, dependent: :destroy

  after_create :create_message_copies

  private

  def create_message_copies
    send_emails = message_thread.messages.last(2).first.created_at < 30.minutes.ago
    message_thread.users.each do |thread_user|
      status = user == thread_user ? 1 : 0
      MessageCopy.create(user: thread_user, message: self, status: status)

      next if user == thread_user || !send_emails
      UserMailer.new_message_alert(thread_user, self).deliver_now
    end
  end
end

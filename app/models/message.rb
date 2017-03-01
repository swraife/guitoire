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
end

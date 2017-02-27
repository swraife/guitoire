# == Schema Information
#
# Table name: user_message_threads
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  message_thread_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class UserMessageThread < ApplicationRecord
  belongs_to :user
  belongs_to :message_thread
end

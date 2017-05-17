# == Schema Information
#
# Table name: performer_message_threads
#
#  id                :integer          not null, primary key
#  performer_id      :integer
#  message_thread_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class PerformerMessageThread < ApplicationRecord
  belongs_to :performer
  belongs_to :message_thread
end

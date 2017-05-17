# == Schema Information
#
# Table name: message_copies
#
#  id           :integer          not null, primary key
#  performer_id :integer
#  message_id   :integer
#  status       :integer          default("unseen")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class MessageCopy < ApplicationRecord
  belongs_to :performer
  belongs_to :message

  enum status: [:unseen, :viewed]

  private
end

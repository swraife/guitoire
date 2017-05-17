# == Schema Information
#
# Table name: message_threads
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MessageThread < ApplicationRecord
  has_many :messages
  has_many :message_copies, through: :messages
  has_many :performer_message_threads
  has_many :performers, through: :performer_message_threads
end

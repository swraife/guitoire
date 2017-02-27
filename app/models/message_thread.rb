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
  has_many :user_message_threads
  has_many :users, through: :user_message_threads
end

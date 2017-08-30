# == Schema Information
#
# Table name: received_emails
#
#  id          :integer          not null, primary key
#  to          :jsonb
#  from        :jsonb
#  body        :text
#  subject     :text
#  sender_type :string
#  sender_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ReceivedEmail < ApplicationRecord
  belongs_to :sender, polymorphic: true
end

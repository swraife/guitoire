# == Schema Information
#
# Table name: follows
#
#  id           :integer          not null, primary key
#  performer_id :integer
#  follower_id  :integer
#  status       :integer          default("active")
#  accepted_at  :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Follow < ApplicationRecord
  include AASM
  include PublicActivity::Model
  include TrackableAssociations

  tracked only: [:create], owner: :follower, recipient: :performer

  belongs_to :performer
  belongs_to :follower, class_name: 'Performer'

  # status no longer used, might be added back to track history
  enum status: [:active]
end

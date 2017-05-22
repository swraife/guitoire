# == Schema Information
#
# Table name: followers
#
#  id           :integer          not null, primary key
#  connector_id :integer
#  connected_id :integer
#  status       :integer          default("pending")
#  accepted_at  :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Follower < ApplicationRecord
  include AASM
  include PublicActivity::Model
  include TrackableAssociations

  belongs_to :connector, class_name: 'Performer'
  belongs_to :connected, class_name: 'Performer'

  enum status: [:active, :inactive]

  aasm column: :status, enum: true do
    state :active, :initial => true
    state :inactive

    event :unfollow do
      transitions from: :active, to: :inactive
    end
  end

  private

  def set_requester_to_connector(requester)
    assign_attributes(connector: connected, connected: connector) if requester == connected
    true
  end

  def requester_is_connected(requester)
    requester == connected
  end

  def update_accepted_at
    self.accepted_at = Time.now
  end

  def create_accepted_activity
    create_activity owner: connector,
                    recipient: connected,
                    key: 'follower.accepted'
  end

  def destroy_accepted_activity
    activities.destroy_all
  end
end

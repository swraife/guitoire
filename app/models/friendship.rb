# == Schema Information
#
# Table name: friendships
#
#  id           :integer          not null, primary key
#  connector_id :integer
#  connected_id :integer
#  status       :integer          default("pending")
#  accepted_at  :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Friendship < ApplicationRecord
  include AASM
  include PublicActivity::Model
  include TrackableAssociations

  belongs_to :connector, class_name: 'Performer'
  belongs_to :connected, class_name: 'Performer'

  enum status: [:pending, :requested, :accepted, :declined]

  aasm column: :status, enum: true do
    state :pending, :initial => true
    state :requested, after_enter: [:create_requested_notification]
    state :accepted, before_enter: :update_accepted_at,
                     after_enter: [:create_accepted_activity, :create_accepted_notification]
    state :declined, after_enter: :destroy_accepted_activity

    event :request do
      transitions from: :pending, to: :requested
      transitions from: :requested, to: :accepted, guard: :requester_is_connected
      transitions from: :requested, to: :requested
      transitions from: :declined, to: :requested, guard: :set_requester_to_connector
    end

    event :decline do
      transitions from: :requested, to: :declined
      transitions from: :accepted, to: :declined
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

  def create_requested_notification
    # TODO: create requested notification for connected.
  end

  def create_accepted_notification
    # TODO: create accepted notification for connector
  end

  def create_accepted_activity
    create_activity owner: connector,
                    recipient: connected,
                    key: 'friendship.accepted'
  end

  def destroy_accepted_activity
    activities.destroy_all
  end
end

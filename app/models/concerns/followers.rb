module Followers
  extend ActiveSupport::Concern

  included do
    has_many :followers_as_connector, class_name: 'Follower', foreign_key: :connector_id, dependent: :destroy
    has_many :followers_as_connected, class_name: 'Follower', foreign_key: :connected_id, dependent: :destroy
  end

  def followers(status = :all)
    Follower.where(connector: self).or(Follower.where(connected: self)).send(status)
  end

  def friends(status = :all)
    Performer.where(id: followers_performer_ids(status).tap { |arr| arr.delete(id) })
  end

  # Note: includes the self performer's id.
  def followers_performer_ids(status = :all)
    followers(status).pluck(:connected_id, :connector_id).flatten
  end

  def follower_with(performer)
    return if performer == self
    t = Follower.arel_table

    followers.where(
      t[:connector_id].eq(performer.id).or(t[:connected_id].eq(performer.id))
    ).first_or_initialize do |follower|
        follower.connector = self
        follower.connected = performer
      end
  end

  Follower.statuses.keys.each do |status|
    define_method("#{status}_followers") { followers status }
    define_method("#{status}_friends") { friends status }
  end
end

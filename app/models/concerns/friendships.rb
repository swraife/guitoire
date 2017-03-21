module Friendships
  extend ActiveSupport::Concern

  included do
    has_many :friendships_as_connector, class_name: 'Friendship', foreign_key: :connector_id
    has_many :friendships_as_connected, class_name: 'Friendship', foreign_key: :connected_id
  end

  def friendships(status = :all)
    Friendship.where(connector: self).or(Friendship.where(connected: self)).send(status)
  end

  def friends(status = :all)
    User.where(id: friendships_user_ids(status).tap { |arr| arr.delete(id) })
  end

  # Note: includes the self user's id.
  def friendships_user_ids(status = :all)
    friendships(status).pluck(:connected_id, :connector_id).flatten
  end

  def friendship_with(user)
    return if user == self
    friendships.where(connector: user).or(Friendship.where(connected: user))
      .first_or_initialize do |friendship|
        friendship.connector = self
        friendship.connected = user
      end
  end

  Friendship.statuses.keys.each do |status|
    define_method("#{status}_friendships") { friendships status }
    define_method("#{status}_friends") { friends status }
  end
end

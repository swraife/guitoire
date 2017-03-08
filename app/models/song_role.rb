# == Schema Information
#
# Table name: song_roles
#
#  id          :integer          not null, primary key
#  song_id     :integer
#  user_id     :integer
#  role        :integer          default("viewer")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  plays_count :integer          default(0)
#

class SongRole < ApplicationRecord
  include PublicActivity::Model

  belongs_to :song
  belongs_to :user

  has_many :plays

  scope :order_by_last_played, -> {
    joins('LEFT JOIN plays on song_roles.id = plays.song_role_id')
    .group('song_roles.id')
    .order("CASE WHEN song_roles.plays_count = 0 THEN '2' ELSE '1' END")
    .order('max(plays.created_at) DESC')
  }
  scope :order_by_plays_count, -> { includes(:plays).order('plays_count DESC') }
  scope :order_by_song_name, -> { order('songs.name') }

  enum role: [:viewer, :admin, :follower]

  after_create :create_follower_activity

  def self.subscriber
    where(role: [1,2])
  end

  def has_edit_permission?
    admin?
  end

  private

  def create_follower_activity
    return unless follower?
    create_activity(recipient: :song,
                    owner: user,
                    trackable: self,
                    key: 'song_role.create_follower')
  end
end

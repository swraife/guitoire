# == Schema Information
#
# Table name: song_roles
#
#  id          :integer          not null, primary key
#  song_id     :integer
#  owner_id    :integer
#  role        :integer          default("viewer")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  plays_count :integer          default(0)
#  owner_type  :string
#

class SongRole < ApplicationRecord
  include PublicActivity::Model

  belongs_to :owner, polymorphic: true
  belongs_to :user, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :group, class_name: 'Group', foreign_key: 'owner_id'
  belongs_to :song

  has_many :plays, dependent: :destroy

  scope :order_by_last_played, -> { left_joins(:plays)
                                    .group('song_roles.id')
                                    .order('max(plays.created_at) DESC NULLS LAST')}
  scope :order_by_plays_count, -> { includes(:plays).order('plays_count DESC') }
  scope :order_by_song_name, -> { order('songs.name') }
  scope :order_by_created_at, -> { order(created_at: :desc) }

  enum role: [:viewer, :admin, :follower]

  after_create :create_follower_activity

  def self.scopes
    # order_by_song_name should be first. The order is the order of display in the select_tag
    [:order_by_song_name, :order_by_created_at, :order_by_plays_count, :order_by_last_played]
  end

  def self.subscriber
    where(role: [1,2])
  end

  def has_edit_permission?
    admin?
  end

  def global_owner
    owner&.to_global_id
  end

  def global_owner=(owner)
    self.owner = GlobalID::Locator.locate owner
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

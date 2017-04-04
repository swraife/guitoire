# == Schema Information
#
# Table name: songs
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :text
#  music_key      :string
#  tempo          :integer
#  composer_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  creator_id     :integer
#  scale          :string
#  time_signature :string
#  permission     :integer          default("copiable")
#  owner_id       :integer
#  owner_type     :string
#  visibility     :integer          default("everyone")
#

class Song < ApplicationRecord
  include GlobalOwner
  include PgSearch
  include PublicActivity::Model
  include TrackableAssociations

  tracked only: [:create], owner: :creator

  has_many :song_roles, dependent: :destroy
  has_many :admin_song_roles, -> { admin }, class_name: 'SongRole'
  has_many :follower_song_roles, -> { follower }, class_name: 'SongRole'
  has_many :viewer_song_roles, -> { viewer }, class_name: 'SongRole'
  has_many :subscriber_song_roles, -> { subscriber }, class_name: 'SongRole'

  has_many :performers, through: :song_roles, source: :owner, source_type: 'Performer'
  has_many :admin_performers, through: :admin_song_roles, source: :owner, source_type: 'Performer'
  has_many :viewer_performers, through: :viewer_song_roles, source: :owner, source_type: 'Performer'
  has_many :follower_performers, through: :follower_song_roles, source: :owner, source_type: 'Performer'

  has_many :groups, through: :song_roles, source: :owner, source_type: 'Group'
  has_many :admin_groups, through: :admin_song_roles, source: :owner, source_type: 'Group'
  has_many :viewer_groups, through: :viewer_song_roles, source: :owner, source_type: 'Group'
  has_many :follower_groups, through: :follower_song_roles, source: :owner, source_type: 'Group'

  belongs_to :composer
  belongs_to :creator, class_name: 'Performer'

  belongs_to :owner, polymorphic: true

  has_many :resources, as: :target, dependent: :destroy
  has_many :file_resources, through: :resources, source: :resourceable, source_type: 'FileResource'
  has_many :url_resources, through: :resources, source: :resourceable, source_type: 'UrlResource'

  has_many :tags, through: :taggings
  has_many :plays, through: :song_roles
  has_many :players, -> { distinct }, through: :plays, source: :performer
  has_many :set_list_songs, dependent: :destroy

  acts_as_taggable_on :composers, :versions, :genres, :generics

  after_create :owner_song_role

  enum permission: [:copiable, :followable, :hidden]
  enum visibility: [:everyone, :friends, :only_admins]

  multisearchable against: :name

  MUSICKEYS = %w(A A# B B# C D D# E F F# G G#)
  SCALES = %w(Major Minor Blues)
  TIME_SIGNATURES = ['4/4', '3/4', '2/4', '3/8']

  # TODO: Add friends to query
  def self.visible_to(performer)
    # Can't currently do in one OR query w/ AR, because of bug w/ joining.
    has_role_ids = joins(:song_roles).where(song_roles: { owner: performer.actors }).ids
    where(visibility: 0).or(where(id: has_role_ids))
  end

  alias_attribute :public_name, :name

  def permissible_roles
    return %w(viewer follower) unless hidden?
    []
  end

  private

  def owner_song_role
    SongRole.create(owner: owner, song_id: id, role: 1)
  end
end

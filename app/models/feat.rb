# == Schema Information
#
# Table name: feats
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

class Feat < ApplicationRecord
  include GlobalOwner
  include PgSearch
  include PublicActivity::Model
  include TrackableAssociations

  tracked only: [:create], owner: :creator, recipient: :itself

  has_many :feat_roles, dependent: :destroy
  has_many :admin_feat_roles, -> { admin }, class_name: 'FeatRole'
  has_many :follower_feat_roles, -> { follower }, class_name: 'FeatRole'
  has_many :viewer_feat_roles, -> { viewer }, class_name: 'FeatRole'
  has_many :subscriber_feat_roles, -> { subscriber }, class_name: 'FeatRole'

  has_many :performers, through: :feat_roles, source: :owner, source_type: 'Performer'
  has_many :admin_performers, through: :admin_feat_roles, source: :owner, source_type: 'Performer'
  has_many :viewer_performers, through: :viewer_feat_roles, source: :owner, source_type: 'Performer'
  has_many :follower_performers, through: :follower_feat_roles, source: :owner, source_type: 'Performer'

  has_many :groups, through: :feat_roles, source: :owner, source_type: 'Group'
  has_many :admin_groups, through: :admin_feat_roles, source: :owner, source_type: 'Group'
  has_many :viewer_groups, through: :viewer_feat_roles, source: :owner, source_type: 'Group'
  has_many :follower_groups, through: :follower_feat_roles, source: :owner, source_type: 'Group'

  belongs_to :composer
  belongs_to :creator, class_name: 'Performer'

  belongs_to :owner, polymorphic: true

  has_many :resources, as: :target, dependent: :destroy
  has_many :file_resources, through: :resources, source: :resourceable, source_type: 'FileResource'
  has_many :url_resources, through: :resources, source: :resourceable, source_type: 'UrlResource'

  has_many :tags, through: :taggings
  has_many :plays, through: :feat_roles
  has_many :players, -> { distinct }, through: :plays, source: :performer
  has_many :routine_feats, dependent: :destroy

  # scope :order_by_last_played, -> { group('feats.id')
  #                                   .order('max(plays.created_at) DESC NULLS LAST') }

  # scope :order_by_last_played, -> { includes(feat_roles: :plays).order('plays.created_at desc NULLS LAST')}

  scope :order_by_plays_count, -> { order('feat_roles.plays_count DESC') }
  scope :order_by_name, -> { order(:name) }

  acts_as_taggable_on :generics

  after_create :owner_feat_role

  enum permission: [:copiable, :followable, :hidden]
  enum visibility: [:everyone, :friends, :only_admins]

  multisearchable against: :name

  accepts_nested_attributes_for :feat_roles

  FEAT_NAMES = %w(song skill trick move).freeze

  # TODO: Add friends to query
  def self.visible_to(performer)
    # Can't currently do in one OR query w/ AR, because of bug w/ joining.
    has_role_ids = joins(:feat_roles).where(feat_roles: { owner: performer.actors }).ids
    where(visibility: 0).or(where(id: has_role_ids))
  end

  alias_attribute :public_name, :name

  def permissible_roles
    hidden? ? [] : %w(viewer follower)
  end

  private

  def owner_feat_role
    FeatRole.where(owner: owner, feat_id: id).first_or_initialize.admin!
  end
end

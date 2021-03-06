# == Schema Information
#
# Table name: feat_roles
#
#  id             :integer          not null, primary key
#  feat_id        :integer
#  owner_id       :integer
#  role           :integer          default("viewer")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  plays_count    :integer          default(0)
#  owner_type     :string
#  last_played_at :datetime
#

class FeatRole < ApplicationRecord
  include PublicActivity::Model
  include GlobalOwner
  include Resourceable

  belongs_to :owner, polymorphic: true
  belongs_to :performer, class_name: 'Performer', foreign_key: 'owner_id'
  belongs_to :group, class_name: 'Group', foreign_key: 'owner_id'
  belongs_to :feat

  has_many :plays, dependent: :destroy

  scope :order_by_last_played, -> { left_joins(:plays)
                                    .group('feat_roles.id')
                                    .order('max(plays.created_at) DESC NULLS LAST') }
  scope :order_by_plays_count, -> { includes(:plays).order('plays_count DESC') }
  scope :order_by_name, -> { order('feats.name') }
  scope :order_by_created_at, -> { order(created_at: :desc) }

  enum role: [:viewer, :admin, :follower]

  acts_as_taggable_on :private

  after_create :create_follower_activity

  def self.scopes
    # order_by_name should be first. The order is the order of display in the select_tag
    [:order_by_name, :order_by_created_at, :order_by_plays_count, :order_by_last_played]
  end

  def self.subscriber
    where(role: [1,2])
  end

  def subscriber?
    admin? || follower?
  end

  def has_edit_permission?
    admin?
  end

  def redirect_target
    feat
  end

  private

  def create_follower_activity
    return unless follower?
    create_activity(recipient: :feat,
                    owner: performer,
                    trackable: self,
                    key: 'feat_role.create_follower')
  end
end

# == Schema Information
#
# Table name: routines
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :integer
#  owner_type  :string
#  visibility  :integer          default("everyone")
#

class Routine < ApplicationRecord
  include GlobalOwner
  include TrackableAssociations
  include PublicActivity::Model

  tracked only: [:create], owner: :owner

  belongs_to :owner, polymorphic: true
  has_many :events

  has_many :routine_roles, dependent: :destroy
  has_many :performers, through: :routine_roles, source: :owner, source_type: 'Performer'
  has_many :groups, through: :routine_roles, source: :owner, source_type: 'Group'

  has_many :set_list_songs, dependent: :destroy
  has_many :songs, through: :set_list_songs

  after_save :owner_routine_role

  enum visibility: [:everyone, :friends, :only_admins]

  # make sure to change this if more routine_role.roles are ever added
  alias_attribute :admin_performers, :performers
  alias_attribute :admin_groups, :groups

  # TODO: Add friends to query
  def self.visible_to(performer)
    # Can't currently do in one OR query w/ AR, because of bug w/ joining.
    has_role_ids = joins(:routine_roles).where(routine_roles: { owner: performer.actors }).ids
    where(visibility: 0).or(where(id: has_role_ids))
  end

  private

  def owner_routine_role
    routine_roles.where(owner: owner).first_or_create
  end
end

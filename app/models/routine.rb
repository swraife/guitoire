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
#

class Routine < ApplicationRecord
  include GlobalOwner
  include TrackableAssociations

  belongs_to :owner, polymorphic: true
  has_many :events

  has_many :routine_roles
  has_many :users, through: :routine_roles, source: :owner, source_type: 'User'
  has_many :groups, through: :routine_roles, source: :owner, source_type: 'Group'

  has_many :set_list_songs
  has_many :songs, through: :set_list_songs

  after_save :owner_routine_role

  def editor_roles_for(actors)
    routine_roles.admin.where(owner: actors)
  end

  private

  def owner_routine_role
    routine_roles.where(owner: owner).first_or_create
  end
end

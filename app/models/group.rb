# == Schema Information
#
# Table name: groups
#
#  id                  :integer          not null, primary key
#  name                :string
#  settings            :jsonb
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  creator_id          :integer
#  description         :text
#  visibility          :integer          default("everyone")
#

class Group < ApplicationRecord
  include Actor
  include GroupRoleable
  include RoutineRoleOwner
  include SongRoleOwner

  has_many :users, through: :group_roles
  has_many :admin_users, through: :admin_group_roles, source: :user
  has_many :member_users, through: :member_group_roles, source: :user

  belongs_to :creator, class_name: 'User'

  has_attached_file :avatar, styles: { medium: '300x300#', thumb: '100x100#' }, default_url: 'https://s3-us-west-2.amazonaws.com/guitoire/assorted/default_avatar.png'
  validates_attachment_content_type :avatar, :content_type => ['image/jpg', 'image/jpeg', 'image/png']

  after_create :creator_group_role

  enum visibility: [:everyone, :only_admins]

  def self.visible_to(user)
    # Can't currently do in one OR query w/ AR, because of bug w/ joining.
    has_role_ids = joins(:group_roles).where(group_roles: { user: user }).ids
    where(visibility: 0).or(where(id: has_role_ids))
  end

  private

  def creator_group_role
    admin_group_roles.where(user_id: creator_id).first_or_create!
  end
end

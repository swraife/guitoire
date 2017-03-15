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
#

class Group < ApplicationRecord
  include Actor
  include GroupRoleable
  include RoutineRoleOwner
  include SongRoleOwner

  has_many :users, through: :group_roles
  has_many :admin_users, through: :admin_group_roles, source: :user

  belongs_to :creator, class_name: 'User'

  has_attached_file :avatar, styles: { medium: '300x300#', thumb: '100x100#' }, default_url: 'https://s3-us-west-2.amazonaws.com/guitoire/assorted/default_avatar.png'
  validates_attachment_content_type :avatar, :content_type => ['image/jpg', 'image/jpeg', 'image/png']

  after_create :creator_group_role

  private

  def creator_group_role
    admin_group_roles.where(user_id: creator_id).first_or_create!
  end
end

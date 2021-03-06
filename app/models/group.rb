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
  include PgSearch
  include RoutineRoleOwner
  include FeatRoleOwner

  has_many :performers, through: :group_roles
  has_many :admin_performers, through: :admin_group_roles, source: :performer
  has_many :member_performers, through: :member_group_roles, source: :performer

  belongs_to :creator, class_name: 'Performer'

  has_attached_file :avatar, styles: { medium: '300x300#', thumb: '100x100#' }, default_url: 'https://s3-us-west-2.amazonaws.com/guitoire/assorted/:style/default_avatar.png'
  validates_attachment_content_type :avatar, :content_type => ['image/jpg', 'image/jpeg', 'image/png']

  store_accessor :settings, :feat_contexts, :feat_role_contexts

  after_create :creator_group_role

  enum visibility: [:everyone, :only_admins]

  multisearchable against: :name

  def self.visible_to(performer)
    ids = performer.group_roles.where(role: %w(member admin)).pluck(:group_id)
    where(visibility: 0).or(where(id: ids))
  end

  alias_attribute :public_name, :name

  private

  def creator_group_role
    admin_group_roles.where(performer_id: creator_id).first_or_create!
  end

  def format_custom_contexts
    if feat_contexts.is_a? Array
      self.feat_contexts = feat_contexts.each_with_object({}) do |context, hsh|
        hsh[Contexts.name_for(context)] = context if context.present?
      end
    elsif feat_contexts.nil?
      self.feat_contexts = {}
    end
  end
end

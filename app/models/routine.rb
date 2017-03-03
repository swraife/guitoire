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
  belongs_to :owner, polymorphic: true
  has_many :events

  has_many :routine_roles
  has_many :users, through: :routine_roles

  has_many :set_list_songs
  has_many :songs, through: :set_list_songs

  after_create :create_routine_role

  private

  def create_routine_role
    routine_roles.create(owner: owner, role: 1)
  end
end

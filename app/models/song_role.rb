# == Schema Information
#
# Table name: song_roles
#
#  id         :integer          not null, primary key
#  song_id    :integer
#  user_id    :integer
#  role       :integer          default("viewer")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SongRole < ApplicationRecord
  include PublicActivity::Model

  belongs_to :song
  belongs_to :user

  enum role: [:viewer, :admin, :follower]

  after_create :create_follower_activity

  def has_edit_permission?
    admin?
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

# == Schema Information
#
# Table name: song_roles
#
#  id          :integer          not null, primary key
#  song_id     :integer
#  user_id     :integer
#  role        :integer          default("viewer")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  plays_count :integer          default(0)
#

class SongRole < ApplicationRecord
  include PublicActivity::Model

  belongs_to :song
  belongs_to :user

  has_many :plays

  enum role: [:viewer, :admin, :follower]

  after_create :create_follower_activity

  def self.subscriber
    where(role: [1,2])
  end

  def has_edit_permission?
    admin?
  end

  def self.sort(sort_by)
    case sort_by
    when :last_played
      # Doesn't work!!!
      order = 'plays.created_at'
    when :plays_count
      order = 'plays_count DESC'
    end
    includes(:plays).order(order)
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

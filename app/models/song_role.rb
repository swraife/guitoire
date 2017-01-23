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
  belongs_to :song
  belongs_to :user

  enum role: [:viewer, :admin, :follower]

  def has_edit_permission?
    admin?
  end
end

# == Schema Information
#
# Table name: song_resources
#
#  id          :integer          not null, primary key
#  song_id     :integer
#  resource_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SongResource < ApplicationRecord
  belongs_to :song
  belongs_to :resource

  after_destroy :destroy_resource

  private

  def destroy_resource
    resource.destroy if resource.song_resources.blank?
  end
end

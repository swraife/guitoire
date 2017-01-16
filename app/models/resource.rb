# == Schema Information
#
# Table name: resources
#
#  id                :integer          not null, primary key
#  name              :string
#  resourceable_type :string
#  resourceable_id   :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Resource < ApplicationRecord
  has_many :song_resources
  has_many :songs, through: :song_resources
  belongs_to :resourceable, polymorphic: true

  after_destroy :destroy_resourceable

  private

  def destroy_resourceable
    resourceable.destroy if resourceable.resources.blank?
  end
end

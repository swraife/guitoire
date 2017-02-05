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
#  target_id         :integer
#  target_type       :string
#  creator_type      :string
#  creator_id        :integer
#

class Resource < ApplicationRecord
  include PublicActivity::Model
  include TrackableAssociations

  tracked only: [:create], owner: :creator, recipient: :target

  belongs_to :resourceable, polymorphic: true
  belongs_to :creator, polymorphic: true
  belongs_to :target, polymorphic: true

  after_destroy :destroy_resourceable

  def destroy_resourceable
    resourceable.destroy if resourceable.resources.count == 0
  end
end

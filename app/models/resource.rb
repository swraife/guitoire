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
#  owner_id          :integer
#  owner_type        :string
#

class Resource < ApplicationRecord
  belongs_to :resourceable, polymorphic: true
  belongs_to :owner, polymorphic: true

  after_destroy :destroy_resourceable

  def destroy_resourceable
    resourceable.destroy if resourceable.resources.count == 0
  end
end

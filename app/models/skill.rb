# == Schema Information
#
# Table name: skills
#
#  id         :integer          not null, primary key
#  name       :string
#  area_id    :integer
#  tag_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Skill < ApplicationRecord
  belongs_to :area
  belongs_to :tag, class_name: 'ActsAsTaggableOn::Tag'

  enum type_of: [:user_input, :permanent]

  before_create :create_tag

  private

  def create_tag
    self.tag = ActsAsTaggableOn::Tag.create(name: name)
  end
end

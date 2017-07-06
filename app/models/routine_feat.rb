# == Schema Information
#
# Table name: routine_feats
#
#  id          :integer          not null, primary key
#  feat_id     :integer
#  routine_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sort_value  :integer
#  name        :string
#  description :text
#

# left as routine_feat until decided what 'feat' will be named
class RoutineFeat < ApplicationRecord
  include Resourceable

  belongs_to :routine
  belongs_to :feat

  before_create :default_sort_value

  # default_scope { order(:sort_value) }

  def default_sort_value
    return if sort_value
    self.sort_value = (routine.routine_feats.pluck(:sort_value).max || 1) + 1000
  end

  def refresh_sort_values!
    routine.routine_feats.each_with_index do |routine_feat, index|
      routine_feat.update(sort_value: (index + 1) * 1000)
    end
  end

  def public_name
    name || feat.name
  end
end

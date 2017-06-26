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

require 'rails_helper'

RSpec.describe RoutineFeat, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

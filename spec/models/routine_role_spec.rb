# == Schema Information
#
# Table name: routine_roles
#
#  id         :integer          not null, primary key
#  owner_id   :integer
#  routine_id :integer
#  role       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_type :string
#

require 'rails_helper'

RSpec.describe RoutineRole, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

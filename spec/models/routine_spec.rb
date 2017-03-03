# == Schema Information
#
# Table name: routines
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :integer
#  owner_type  :string
#

require 'rails_helper'

RSpec.describe Routine, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

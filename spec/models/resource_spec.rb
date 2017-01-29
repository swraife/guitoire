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

require 'rails_helper'

RSpec.describe Resource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

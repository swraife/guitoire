# == Schema Information
#
# Table name: feat_roles
#
#  id             :integer          not null, primary key
#  feat_id        :integer
#  owner_id       :integer
#  role           :integer          default("viewer")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  plays_count    :integer          default(0)
#  owner_type     :string
#  last_played_at :datetime
#

require 'rails_helper'

RSpec.describe FeatRole, type: :model do
  let(:feat) { FactoryGirl.create(:feat) }
  let(:feat_role) { FactoryGirl.create(:feat_role, feat: feat, owner: performer) }
  let(:performer) { FactoryGirl.create(:performer) }
end

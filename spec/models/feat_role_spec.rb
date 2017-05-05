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

  describe '.order_by_plays_count' do
    it 'sorts by plays_count' do
      2.times { Play.create(feat_role: feat_role, performer: performer) }
      Play.create(feat_role: Feat.create(name: 'A', creator: performer).feat_roles.first, performer: performer)

      expect(described_class.order_by_plays_count.first).to eq(feat_role)
    end
  end
end

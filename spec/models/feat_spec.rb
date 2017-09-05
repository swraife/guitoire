# == Schema Information
#
# Table name: feats
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :text
#  music_key      :string
#  tempo          :integer
#  composer_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  creator_id     :integer
#  scale          :string
#  time_signature :string
#  permission     :integer          default("copiable")
#  owner_id       :integer
#  owner_type     :string
#  visibility     :integer          default("everyone")
#  plays_count    :integer          default(0)
#  last_played_at :datetime
#  status         :integer          default("published")
#

require 'rails_helper'

RSpec.describe Feat, type: :model do
  let(:feat) { FactoryGirl.create(:feat, creator: performer, owner: performer) }
  let(:performer) { FactoryGirl.create(:performer) }

  describe '#order_by_last_played' do
    let(:feat2) { create(:feat, owner: performer) }
    let!(:first_play) { create(:play, feat_role: feat.feat_roles.first, created_at: 2.days.ago) }
    let!(:second_play) { create(:play, feat_role: feat2.feat_roles.first, created_at: 1.days.ago) }

    xit 'does it' do
      expect(described_class.order_by_last_played.to_a).to eq([feat2, feat])
    end

    context 'when multiple performers play the feat' do
      xit 'does it' do
        other_feat_role = create(:feat_role, feat: feat, owner: create(:performer))
        # create(:play, feat_role: other_feat_role)

        expect(performer.feats.order_by_last_played.to_a).to eq([feat2, feat])
      end
    end
  end
end

require 'rails_helper'

RSpec.describe FeatRoleUpdater do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:feat) { FactoryGirl.create(:feat, owner: performer) }

  describe '#update!' do
    it 'adds the feat owner as an admin' do
      described_class.new(feat, [], []).update!

      expect(feat.admin_performers).to include(performer)
    end

    it 'deletes admin feat_roles not in admin_performer_ids' do
      admin = FactoryGirl.create(:performer)
      feat.admin_performers << admin

      described_class.new(feat, [], []).update!
      expect(feat.admin_performers.reload).to_not include(admin)
    end

    context 'performer is in admin_performer_ids' do
      it 'creates an admin feat_role' do
        new_admin = FactoryGirl.create(:performer)
        described_class.new(feat, [new_admin.id], []).update!

        expect(feat.admin_performers.reload).to include(new_admin)
      end

      it 'makes performer with existing feat_role an admin' do
        follower = FactoryGirl.create(:performer)
        feat.follower_performers << follower
        described_class.new(feat, [follower.id], []).update!
        feat.reload

        expect(feat.admin_performers.reload).to include(follower)
      end
    end
  end
end

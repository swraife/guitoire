require 'rails_helper'

RSpec.describe SongRoleUpdater do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:song) { FactoryGirl.create(:song, owner: performer) }

  describe '#update!' do
    it 'adds the song owner as an admin' do
      described_class.new(song, [], []).update!

      expect(song.admin_performers).to include(performer)
    end

    it 'deletes admin song_roles not in admin_performer_ids' do
      admin = FactoryGirl.create(:performer)
      song.admin_performers << admin

      described_class.new(song, [], []).update!
      expect(song.admin_performers.reload).to_not include(admin)
    end

    context 'performer is in admin_performer_ids' do
      it 'creates an admin song_role' do
        new_admin = FactoryGirl.create(:performer)
        described_class.new(song, [new_admin.id], []).update!

        expect(song.admin_performers.reload).to include(new_admin)
      end

      it 'makes performer with existing song_role an admin' do
        follower = FactoryGirl.create(:performer)
        song.follower_performers << follower
        described_class.new(song, [follower.id], []).update!
        song.reload

        expect(song.admin_performers.reload).to include(follower)        
      end
    end
  end
end

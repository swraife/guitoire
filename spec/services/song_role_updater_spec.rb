require 'rails_helper'

RSpec.describe SongRoleUpdater do
  let(:user) { FactoryGirl.create(:user) }
  let(:song) { FactoryGirl.create(:song, owner: user) }

  describe '#update!' do
    it 'adds the song owner as an admin' do
      described_class.new(song, [], []).update!

      expect(song.admin_users).to include(user)
    end

    it 'deletes admin song_roles not in admin_user_ids' do
      admin = FactoryGirl.create(:user)
      song.admin_users << admin

      described_class.new(song, [], []).update!
      expect(song.admin_users.reload).to_not include(admin)
    end

    context 'user is in admin_user_ids' do
      it 'creates an admin song_role' do
        new_admin = FactoryGirl.create(:user)
        described_class.new(song, [new_admin.id], []).update!

        expect(song.admin_users.reload).to include(new_admin)
      end

      it 'makes user with existing song_role an admin' do
        follower = FactoryGirl.create(:user)
        song.follower_users << follower
        described_class.new(song, [follower.id], []).update!
        song.reload

        expect(song.admin_users.reload).to include(follower)        
      end
    end
  end
end

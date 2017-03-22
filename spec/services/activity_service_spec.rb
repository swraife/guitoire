require 'rails_helper'

RSpec.describe ActivityService do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:subject) { described_class.new(performer) }

  describe '#dashboard_activities' do
    context 'for activities where trackable.everyone is true' do
      it 'returns song.create activities' do
        song = FactoryGirl.create(:song)

        expect(subject.dashboard_activities).to include(song.activities.first)
      end
    end

    context 'for activities where trackable.friends is true' do
      it 'does not return song.create activities when performer is not a friend' do
        pending
        song = FactoryGirl.create(:song, visibility: 'friends')

        expect(subject.dashboard_activities).not_to include(song.activities.first)
      end
    end

    context 'for activities where owner.everyone is true' do
      it 'returns friendship.create activities' do
        friendship = FactoryGirl.create(:accepted_friendship)

        expect(subject.dashboard_activities).to include(friendship.activities.first)
      end
    end
  end
end
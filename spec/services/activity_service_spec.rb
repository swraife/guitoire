require 'rails_helper'

RSpec.describe ActivityService do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:performer2) { FactoryGirl.create(:performer) }
  let(:subject) { described_class.new(performer) }

  describe '#dashboard_activities' do
    let(:subject) { described_class.new(performer).dashboard_activities }

    context 'song.create activities' do
      let(:song) { FactoryGirl.create(:song, owner: performer2, creator: performer2, visibility: visibility) }

      context 'song visibility is everyone' do
        let(:visibility) { 'everyone' }

        it 'returns song.create activities' do
          expect(subject).to include(song.activities.first)
        end

        it 'returns the activity when song.owner visibility is :friends' do
          song.owner.friends!
          expect(subject).to include(song.activities.first)
        end
      end

      context 'song visibility is friends' do
        let(:visibility) { 'friends' }

        it 'does not return the activity when performer is not a friend' do
          expect(subject).not_to include(song.activities.first)
        end

        it 'returns the activity when performer is a friend' do
          FactoryGirl.create(:accepted_friendship, connector: song.owner, connected: performer)
          expect(subject).to include(song.activities.first)
        end
      end

      context 'song visibility is only_admins' do
        let(:visibility) { 'only_admins' }

        it 'does not return the activity when performer is not an admin' do
          expect(subject).not_to include(song.activities.first)
        end

        it 'does return the activity when performer is an admin' do
          song.admin_performers << performer
          expect(subject).to include(song.activities.first)
        end
      end

    end

    context 'routine.create activities' do
      it 'returns the activity' do
        routine = FactoryGirl.create(:routine)

        expect(subject).to include(routine.activities.first)
      end

      it 'doesn\'t return the activity if routine.visibility is only_admins' do
        routine = FactoryGirl.create(:routine, visibility: 'only_admins')

        expect(subject).not_to include(routine.activities.first)
      end
    end

    context 'friendship.accepted activities' do
      xit 'returns friendship.create activities' do
        friendship = FactoryGirl.create(:accepted_friendship)

        expect(subject).to include(friendship.activities.first)
      end
    end

    context 'for play.create activities' do
      context 'when the song is visibility to everyone' do
        it 'returns the activity' do
          play = FactoryGirl.create(:play)

          expect(subject).to include(play.activities.first)
        end

        context 'when the play performer is visible to friends' do
          it 'includes the activity if viewer is friends with play.performer' do
            play = FactoryGirl.create(:play)
            play.performer.friends!
            FactoryGirl.create(:accepted_friendship, connector: performer, connected: play.performer)

            expect(subject).to include(play.activities.first)
          end

          it 'doesn\'t include the activity if viewer is not friends with play.performer' do
            play = FactoryGirl.create(:play)
            play.performer.friends!

            expect(subject).not_to include(play.activities.first)
          end
        end
      end

      context 'when the song is visible to friends' do
        it 'returns the activity if viewer is friends with song.owner' do
          friendship = FactoryGirl.create(:accepted_friendship, connector: performer)
          song = FactoryGirl.create(:song, visibility: 'friends', owner: friendship.connected)
          play = FactoryGirl.create(:play, song_role: song.song_roles.first)

          expect(subject).to include(play.activities.first)
        end

        it 'doesn\'t return the activity to non-friends' do
          song = FactoryGirl.create(:song, visibility: 'friends')
          play = FactoryGirl.create(:play, song_role: song.song_roles.first)

          expect(subject).not_to include(play.activities.first)
        end
      end

      context 'when the song is visible to only_admins' do
        it 'returns the activity if performer is a song admin' do
          song = FactoryGirl.create(:song, visibility: 'only_admins', owner: performer)
          play = FactoryGirl.create(:play, song_role: song.song_roles.first)

          expect(subject).to include(play.activities.first)
        end

        it 'doesn\'t return the activity if performer is not a song admin' do
          song = FactoryGirl.create(:song, visibility: 'only_admins')
          play = FactoryGirl.create(:play, song_role: song.song_roles.first)

          expect(subject).not_to include(play.activities.first)
        end
      end
    end

    context 'for resource.create activities' do
      let(:song) { FactoryGirl.create(:song) }
      context 'when the song is visibility to everyone' do
        it 'returns the activity' do
          resource = FactoryGirl.create(:resource, creator: performer2, target: song)
          expect(subject).to include(resource.activities.first)
        end

        context 'when the resource creator is visible to friends' do
          it 'includes the activity if viewer is friends with resource.creator' do
            resource = FactoryGirl.create(:resource, creator: performer2, target: song)
            resource.creator.friends!
            FactoryGirl.create(:accepted_friendship, connector: performer, connected: resource.creator)

            expect(subject).to include(resource.activities.first)
          end

          it 'doesn\'t include the activity if viewer is not friends with resource.creator' do
            resource = FactoryGirl.create(:resource, creator: performer2)
            resource.creator.friends!

            expect(subject).not_to include(resource.activities.first)
          end
        end
      end

      context 'when the song is visible to friends' do
        it 'returns the activity if viewer is friends with song.owner' do
          friendship = FactoryGirl.create(:accepted_friendship, connector: performer)
          song = FactoryGirl.create(:song, visibility: 'friends', owner: friendship.connected)
          resource = FactoryGirl.create(:resource, target: song, creator: friendship.connected)

          expect(subject).to include(resource.activities.first)
        end

        it 'doesn\'t return the activity to non-friends' do
          song = FactoryGirl.create(:song, visibility: 'friends')
          resource = FactoryGirl.create(:resource, target: song)

          expect(subject).not_to include(resource.activities.first)
        end
      end

      context 'when the song is visible to only_admins' do
        it 'returns the activity if performer is a song admin' do
          song = FactoryGirl.create(:song, visibility: 'only_admins')
          song.admin_performers << performer
          resource = FactoryGirl.create(:resource, target: song, creator: performer2)

          expect(subject).to include(resource.activities.first)
        end

        it 'doesn\'t return the activity if performer is not a song admin' do
          song = FactoryGirl.create(:song, visibility: 'only_admins')
          resource = FactoryGirl.create(:resource, target: song)

          expect(subject).not_to include(resource.activities.first)
        end
      end
    end

    context 'for song_role.create_follower activities' do
      let(:song) { FactoryGirl.create(:song, creator: performer2, owner: performer2, visibility: visibility) }
      let(:song_role) { FactoryGirl.create(:song_role, role: 'follower', song: song) }

      context 'when the song is visible to everyone' do
        let(:visibility) { 'everyone' }

        it 'returns the activity' do
          expect(subject).to include(song_role.activities.first)
        end

        context 'when the activity.owner visibility is :friends' do
          it 'does not return the activity if performer is not a friend' do
            song_role.owner.friends!
            expect(subject).not_to include(song_role.activities.first)
          end

          it 'does return the activity performer is a friend' do
            song_role.owner.friends!
            friendship = FactoryGirl.create(:accepted_friendship, connected: performer, connector: song_role.owner)
            expect(subject).to include(song_role.activities.first)
          end
        end
      end

      context 'when the song is visible to friends' do
        let(:visibility) { 'friends' }

        it 'doesn\'t return the activity if performer is not a friend' do
          expect(subject).not_to include(song_role.activities.first)
        end

        it 'does return the activity if performer is a friend' do
          friendship = FactoryGirl.create(:accepted_friendship, connected: performer, connector: song.creator)
          expect(subject).to include(song_role.activities.first)
        end
      end
    end
  end
end

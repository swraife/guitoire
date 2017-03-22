require 'cancan/matchers'

describe Ability do
  describe 'abilities' do
    subject(:ability) { Ability.new(performer, {}) }
    let(:performer) { Performer.new(user: User.new) }

    context 'when performer is a subscriber' do
      let(:other_performer) { FactoryGirl.create(:performer) }

      context 'for objects belonging to an owner' do
        [Song, Routine, RoutineRole].each do |klass|
          it { expect(ability).to be_able_to(:create, klass.new(owner: performer)) }
          it { expect(ability).not_to be_able_to(:create, klass.new(owner: other_performer)) }
        end
      end

      context 'for song_roles' do
        let(:ability) { Ability.new(performer, { song_role: { role: 'follower'} }) }
        it { expect(ability).to be_able_to(:create, SongRole.new(owner: performer, song: Song.new)) }
        it { expect(ability).not_to be_able_to(:create, SongRole.new(owner: other_performer)) }
      end

      context 'for songs' do
        let(:song) { Song.new(owner: other_performer) }

        it { expect(ability).to be_able_to(:show, song) }
        it { expect(ability).not_to be_able_to(:show, song.tap { |u| u.visibility = 2 }) }

        it 'allows admin_performers to be shown a private song' do
          song.visibility = 2
          song.admin_performers << performer
          expect(ability).to be_able_to(:show, song)
        end

        context 'copiable permissions' do
          it 'can copy when song is copiable?' do
            expect(ability).to be_able_to(:copy, song)
          end

          it 'cannot copy when song is not copiable?' do
            song.permission = Song.permissions[:followable]
            expect(ability).not_to be_able_to(:copy, song)
          end
        end

        context 'followable permissions' do
          it 'can follow when song is not hidden' do
            expect(ability).to be_able_to(:follow, song)
          end

          it 'cannot follow when song is hidden' do
            song.permission = Song.permissions[:hidden]
            expect(ability).not_to be_able_to(:follow, song)
          end
        end
      end

      context 'for routines' do
        let(:routine) { Routine.new(owner: other_performer) }

        it { expect(ability).to be_able_to(:show, routine) }

        it 'a non-friend cannot :index a private performer\'s routines' do
          other_performer.friends!
          expect(described_class.new(performer, { performer_id: other_performer.id }))
            .not_to be_able_to(:index, Routine)
        end
      end

      context 'for groups' do
        let(:group) { Group.new }

        it { expect(ability).to be_able_to(:create, group) }
      end

      context 'for set_list_songs' do
        let(:routine) { Routine.new(owner: performer).tap { |r| r.admin_performers << performer} }
        let(:set_list_song) { routine.set_list_songs.new }

        it { expect(ability).to be_able_to(:create, set_list_song) }
      end

      context 'for plays' do
        let(:play) { Play.new(performer: performer, song: Song.new) }

        it { expect(ability).to be_able_to(:create, play) }
      end
    end
  end
end
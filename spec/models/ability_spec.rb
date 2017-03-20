require 'cancan/matchers'

describe Ability do
  describe 'abilities' do
    subject(:ability) { Ability.new(user, {}) }
    let(:user) { User.new }

    context 'when user is a subscriber' do
      let(:other_user) { FactoryGirl.create(:user) }

      context 'for objects belonging to an owner' do
        [Song, Routine, RoutineRole].each do |klass|
          it { expect(ability).to be_able_to(:create, klass.new(owner: user)) }
          it { expect(ability).not_to be_able_to(:create, klass.new(owner: other_user)) }
        end
      end

      context 'for song_roles' do
        let(:ability) { Ability.new(user, { song_role: { role: 'follower'} }) }
        it { expect(ability).to be_able_to(:create, SongRole.new(owner: user, song: Song.new)) }
        it { expect(ability).not_to be_able_to(:create, SongRole.new(owner: other_user)) }
      end

      context 'for songs' do
        let(:song) { Song.new(owner: other_user) }

        it { expect(ability).to be_able_to(:show, song) }
        it { expect(ability).not_to be_able_to(:show, song.tap { |u| u.visibility = 2 }) }

        it 'allows admin_users to be shown a private song' do
          song.visibility = 2
          song.admin_users << user
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
        let(:routine) { Routine.new(owner: other_user) }

        it { expect(ability).to be_able_to(:show, routine) }

        it 'a non-friend cannot :index a private user\'s routines' do
          other_user.friends!
          expect(described_class.new(user, { user_id: other_user.id }))
            .not_to be_able_to(:index, Routine)
        end
      end

      context 'for groups' do
        let(:group) { Group.new }

        it { expect(ability).to be_able_to(:create, group) }
      end

      context 'for set_list_songs' do
        let(:routine) { Routine.new(owner: user).tap { |r| r.admin_users << user} }
        let(:set_list_song) { routine.set_list_songs.new }

        it { expect(ability).to be_able_to(:create, set_list_song) }
      end

      context 'for plays' do
        let(:play) { Play.new(user: user, song: Song.new) }

        it { expect(ability).to be_able_to(:create, play) }
      end
    end
  end
end
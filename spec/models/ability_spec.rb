require 'cancan/matchers'

describe Ability do
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { User.new }

    context 'when user is a subscriber' do
      let(:other_user) { FactoryGirl.create(:user) }

      context 'for objects belonging to an owner' do
        [Song, SongRole, Routine, RoutineRole].each do |klass|
          it { expect(ability).to be_able_to(:create, klass.new(owner: user)) }
          it { expect(ability).not_to be_able_to(:create, klass.new(owner: other_user)) }
        end
      end

      context 'for songs' do
        let(:song) { Song.new(owner: other_user) }

        it { expect(ability).to be_able_to(:read, song) }
        it { expect(ability).not_to be_able_to(:read, song.tap { |u| u.visibility = 2 }) }

        it 'allows admin_users to read a private song' do
          song.visibility = 2
          song.admin_users << user
          expect(ability).to be_able_to(:read, song)
        end
      end
    end
  end
end
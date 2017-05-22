require 'cancan/matchers'

describe Ability do
  describe 'abilities' do
    subject(:ability) { Ability.new(performer, {}) }
    let(:performer) { Performer.new(user: User.new) }

    context 'when performer is a subscriber' do
      let(:other_performer) { FactoryGirl.create(:performer) }

      context 'for objects belonging to an owner' do
        [Feat, Routine, RoutineRole].each do |klass|
          it { expect(ability).to be_able_to(:create, klass.new(owner: performer)) }
          it { expect(ability).not_to be_able_to(:create, klass.new(owner: other_performer)) }
        end
      end

      context 'for feat_roles' do
        let(:ability) { Ability.new(performer, { feat_role: { role: 'follower'} }) }
        it { expect(ability).to be_able_to(:create, FeatRole.new(owner: performer, feat: Feat.new)) }
        it { expect(ability).not_to be_able_to(:create, FeatRole.new(owner: other_performer)) }
      end

      context 'for feats' do
        let(:feat) { Feat.new(owner: other_performer) }

        it { expect(ability).to be_able_to(:show, feat) }
        it { expect(ability).not_to be_able_to(:show, feat.tap { |u| u.visibility = Feat.visibilities[:only_admins] }) }

        it 'allows admin_performers to be shown an :only_admins feat' do
          feat.visibility = Feat.visibilities[:only_admins]
          feat.admin_performers << performer
          expect(ability).to be_able_to(:show, feat)
        end

        context 'copiable permissions' do
          it 'can copy when feat is copiable?' do
            expect(ability).to be_able_to(:copy, feat)
          end

          it 'cannot copy when feat is not copiable?' do
            feat.permission = Feat.permissions[:followable]
            expect(ability).not_to be_able_to(:copy, feat)
          end
        end

        context 'followable permissions' do
          it 'can follow when feat is not hidden' do
            expect(ability).to be_able_to(:follow, feat)
          end

          it 'cannot follow when feat is hidden' do
            feat.permission = Feat.permissions[:hidden]
            expect(ability).not_to be_able_to(:follow, feat)
          end
        end
      end

      context 'for routines' do
        let(:routine) { Routine.new(owner: other_performer) }

        it { expect(ability).to be_able_to(:show, routine) }

        it 'cannot :index a hidden performer\'s routines' do
          other_performer.hidden!
          expect(described_class.new(performer, { performer_id: other_performer.id }))
            .not_to be_able_to(:index, Routine)
        end
      end

      context 'for groups' do
        let(:group) { Group.new }

        it { expect(ability).to be_able_to(:create, group) }
      end

      context 'for routine_feats' do
        let(:routine) { Routine.new(owner: performer).tap { |r| r.admin_performers << performer} }
        let(:routine_feat) { routine.routine_feats.new }

        it { expect(ability).to be_able_to(:create, routine_feat) }
      end

      context 'for plays' do
        let(:play) { Play.new(performer: performer, feat: Feat.new) }

        it { expect(ability).to be_able_to(:create, play) }
      end
    end
  end
end
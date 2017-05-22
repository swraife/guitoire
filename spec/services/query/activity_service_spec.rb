require 'rails_helper'

RSpec.describe Query::ActivityService do
  let(:area) { create(:area) }
  let(:performer) { FactoryGirl.create(:performer, area: area) }
  let(:performer2) { FactoryGirl.create(:performer, area: area) }
  let(:subject) { described_class.new(performer) }

  describe '#dashboard_activities' do
    let(:subject) { described_class.new(performer).dashboard_activities }

    context 'for feat.create activities' do
      let(:feat) { FactoryGirl.create(:feat, owner: performer2, creator: performer2, visibility: visibility) }

      context 'when feat visibility is everyone' do
        let(:visibility) { 'everyone' }

        it 'returns feat.create activities' do
          feat
          expect(subject).to include(feat.activities.first)
        end

        it 'returns the activity when feat.owner visibility is :hidden' do
          feat.owner.hidden!
          expect(subject).to include(feat.activities.first)
        end
      end

      context 'feat visibility is only_admins' do
        let(:visibility) { 'only_admins' }

        it 'does not return the activity when performer is not an admin' do
          expect(subject).not_to include(feat.activities.first)
        end

        it 'does return the activity when performer is an admin' do
          feat.admin_performers << performer
          expect(subject).to include(feat.activities.first)
        end
      end
    end

    context 'routine.create activities' do
      it 'returns the activity' do
        routine = FactoryGirl.create(:routine, owner: performer2)

        expect(subject).to include(routine.activities.first)
      end

      it 'doesn\'t return the activity if routine.visibility is only_admins' do
        routine = FactoryGirl.create(:routine, visibility: 'only_admins')

        expect(subject).not_to include(routine.activities.first)
      end
    end

    context 'for play.create activities' do
      context 'when the feat is visibility to everyone' do
        it 'returns the activity' do
          feat_role = create(:feat_role, owner: performer2)
          play = FactoryGirl.create(:play, feat_role: feat_role, feat: feat_role.feat)
          expect(subject).to include(play.activities.first)
        end

        context 'when the play performer is :hidden' do
          it 'doesn\'t include the activity' do
            play = FactoryGirl.create(:play)
            play.performer.hidden!

            expect(subject).not_to include(play.activities.first)
          end
        end
      end

      context 'when the feat is visible to only_admins' do
        it 'returns the activity if performer is a feat admin' do
          feat = FactoryGirl.create(:feat, visibility: 'only_admins', owner: performer)
          play = FactoryGirl.create(:play, feat_role: feat.feat_roles.first)

          expect(subject).to include(play.activities.first)
        end

        it 'doesn\'t return the activity if performer is not a feat admin' do
          feat = FactoryGirl.create(:feat, visibility: 'only_admins')
          play = FactoryGirl.create(:play, feat_role: feat.feat_roles.first)

          expect(subject).not_to include(play.activities.first)
        end
      end
    end

    context 'for resource.create activities' do
      let(:feat) { FactoryGirl.create(:feat) }
      context 'when the feat is visibility to everyone' do
        it 'returns the activity' do
          resource = FactoryGirl.create(:resource, creator: performer2, target: feat)
          expect(subject).to include(resource.activities.first)
        end

        context 'when the resource creator is hidden' do
          it 'doesn\'t include the activity' do
            resource = FactoryGirl.create(:resource, creator: performer2)
            resource.creator.hidden!

            expect(subject).not_to include(resource.activities.first)
          end
        end
      end

      context 'when the feat is visible to only_admins' do
        it 'returns the activity if performer is a feat admin' do
          feat = FactoryGirl.create(:feat, visibility: 'only_admins')
          feat.admin_performers << performer
          resource = FactoryGirl.create(:resource, target: feat, creator: performer2)

          expect(subject).to include(resource.activities.first)
        end

        it 'doesn\'t return the activity if performer is not a feat admin' do
          feat = FactoryGirl.create(:feat, visibility: 'only_admins')
          resource = FactoryGirl.create(:resource, target: feat)

          expect(subject).not_to include(resource.activities.first)
        end
      end
    end

    context 'for feat_role.create_follower activities' do
      let(:feat) { FactoryGirl.create(:feat, creator: performer2, owner: performer2, visibility: visibility) }
      let(:feat_role) { FactoryGirl.create(:feat_role, role: 'follower', feat: feat, owner: create(:performer, area: area)) }

      context 'when the feat is visible to everyone' do
        let(:visibility) { 'everyone' }

        it 'returns the activity' do
          feat_role
          expect(subject).to include(feat_role.activities.first)
        end

        context 'when the activity.owner visibility is :hidden' do
          it 'does not return the activity' do
            feat_role.owner.hidden!
            expect(subject).not_to include(feat_role.activities.first)
          end
        end
      end
    end

    context 'for the performer\'s followed\'s activities' do
      let(:follow) do
        create(:follow, follower: performer)
      end

      it 'returns feat.create activities' do
        followed = follow.performer
        feat = create(:feat, owner: followed, creator: followed)

        expect(subject).to include(feat.activities.first)
      end

      it 'returns follow.create activities' do
        follow2 = create(:follow, follower: follow.performer)

        expect(subject).to include(follow2.activities.first)
      end
    end

    context 'for activities tagged with the performer\'s skills' do
      let(:tag) { create(:tag) }

      context 'the happy path' do
        it 'returns feat.create activities' do
          performer.update(standard_skill_ids: [tag.id])
          feat = create(:feat, generic_list: [tag.name])
          performer.reload
          expect(subject).to include(feat.activities.first)
        end
      end

      context 'the unhappy path' do
        it 'does not return feat.create activities tagged with other skills' do
          feat = create(:feat, generic_list: [tag.name])
          performer.reload
          expect(subject).not_to include(feat.activities.first)
        end
      end
    end
  end
end
